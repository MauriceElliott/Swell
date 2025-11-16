import Foundation

enum InputAction {
	case continueReading
    case readHistory
	case submitInput
}

typealias InputHandler = (
	_ sequence: String,
	_ prompt: inout PromptState,
) -> InputAction

func readRawInput() -> String? {
    var oldTerm = termios()
    tcgetattr(STDIN_FILENO, &oldTerm)
    var newTerm = oldTerm;
    cfmakeraw(&newTerm)
    tcsetattr(STDIN_FILENO, TCSANOW, &newTerm)

    var cCharacter: [CChar] = [0, 0]
    let readBytes = read(STDIN_FILENO, &cCharacter, 1)

    tcsetattr(STDIN_FILENO, TCSANOW, &oldTerm)
    if readBytes > 0 {
        return String(cString: cCharacter)
    } else {
        return nil
    }
}

func readInput(state: inout SessionState) -> String {
    var promptState = PromptState(prompt: getPrompt(state: state), content: "", cursorPosition: 0)
    var input = ""

    var continueReading = true
    var readingArrowKeys = false

    while continueReading {
        let sCharacter = readRawInput()
        if sCharacter != nil {
            switch sCharacter! {
            case "\r":
                continueReading = false
                print("\n", terminator: "")
            case "\t":
                let completed = tabComplete(fuzz: input, state: state)
                if completed != input {
                    input += completed
                    print(completed, terminator: "")
                }
            case "\u{7F}":  // Handle backspace (ASCII 127)
                if !input.isEmpty {
                    input.removeLast()
                    print("\u{1B}[1D\u{1B}[K", terminator: "")
                }
            case "\u{1B}":
                readingArrowKeys = true;
            case "[":
                if !readingArrowKeys {
                    readingArrowKeys = false
                    fallthrough
                }
            case "B":
                if readingArrowKeys {
                    for _ in input {
                        print("\u{1B}[D\u{1B}[K", terminator: "")
                    }
                    let previousHistory = readHistory(direction: direction.down, state: &state)
                    input = previousHistory
                    print(input, terminator: "")
                    readingArrowKeys = false
                } else {
                    fallthrough
                }
            case "A":
                if readingArrowKeys {
                    for _ in input {
                        print("\u{1B}[D\u{1B}[K", terminator: "")
                    }
                    let historyEntry = readHistory(direction: direction.up, state: &state)
                    input = historyEntry
                    print(historyEntry, terminator: "")
                    readingArrowKeys = false
                } else {
                    fallthrough
                }
            default:
                print(sCharacter!, terminator: "")
                input += sCharacter!
            }
            fflush(stdout)
        }
    }

    return input
}

enum direction {
    case up
    case down
}

func readHistory(direction: direction, state: inout SessionState) -> String {
    if (state.historyIndex < 0) {
        state.historyIndex = 0
    } else if (state.historyIndex >= state.history.count) {
        state.historyIndex = state.history.count - 1
    }
    let entry = state.history[state.historyIndex]
    var result = ""
    for arg in entry.arguments {
        result += arg + " "
    }
    state.historyIndex = direction == .up ? state.historyIndex - 1: state.historyIndex + 1;
    return result
}


func tabComplete(fuzz: String, state: borrowing SessionState) -> String {
    if fuzz.count == 0 {
        return ""
    }
    if fuzz.split(separator: " ").count == 1 && fuzz.last != " " {
        let startsWith = state.availableCommands.filter{$0.starts(with: fuzz)}
        if(startsWith.count > 0) {
            return startsWith.first!.replacingOccurrences(of: fuzz, with: "")
        }
    } else if fuzz.split(separator: " ").count > 1 || fuzz.last == " " {
        //to be continued, this needs to autocomplete paths
    }
    
    return fuzz
}
