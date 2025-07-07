import Foundation

func readInput() -> String {
    //Set terminal to take raw input (this means you don't need to wait for an enter to parse the typed input)
    var input = ""

    var continueReading = true
    var readingArrowKeys = false
    
    while continueReading {
        var oldTerm = termios()
        tcgetattr(STDIN_FILENO, &oldTerm)
        var newTerm = oldTerm;
        cfmakeraw(&newTerm)
        tcsetattr(STDIN_FILENO, TCSANOW, &newTerm)
        
        var cCharacter: [CChar] = [0, 0]
        let readBytes = read(STDIN_FILENO, &cCharacter, 1)


        tcsetattr(STDIN_FILENO, TCSANOW, &oldTerm)
        if readBytes > 0 {
            //required due to stdout not printing while in raw mode "\u{fffd}"
            let sCharacter = String(cString: cCharacter)
            switch sCharacter {
            case "\r":
                continueReading = false
                print("\n", terminator: "")
            case "\t":
                let completed = tabComplete(fuzz: input)
                if completed != input {
                    input += completed
                    print(completed, terminator: "")
                }
            case "\u{7F}":  // Handle backspace (ASCII 127)
                if !input.isEmpty {
                    input.removeLast()
                    print("\u{1B}[1D\u{1B}[K", terminator: "")
                }
                
            /*
             So, when sending an up or down arrow key as raw input
             u{1B} is sent, followed by a lone [ followed by either A or B
             In other scenarios, you'd expect them to be sent all at once
             But for some reason in my case they are being sent separately.
             
             TODO: Fix up and down arrow input handling
             Either this needs to be abstracted or I need to find a better way to resolve this?
             */

            case "\u{1B}":
                readingArrowKeys = true;
            case "[":
                if !readingArrowKeys {
                    readingArrowKeys = false
                    fallthrough
                }
            case "B":
                if readingArrowKeys {
                    for i in input {
                        print("\u{1B}[D\u{1B}[K", terminator: "")
                    }
                    let previousHistory = readHistory(direction: direction.down)
                    input = previousHistory
                    print(input, terminator: "")
                    readingArrowKeys = false
                } else {
                    fallthrough
                }
            case "A":
                if readingArrowKeys {
                    for i in input {
                        print("\u{1B}[D\u{1B}[K", terminator: "")
                    }
                    let historyEntry = readHistory(direction: direction.up)
                    input = historyEntry
                    print(historyEntry, terminator: "")
                    readingArrowKeys = false
                } else {
                    fallthrough
                }
            default:
                print(sCharacter, terminator: "")
                input += sCharacter
            }
            fflush(stdout)
        }
    }

    return input
}

