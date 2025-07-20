import Foundation
#if os(Windows)
// Windows way of reading from the commandline.
import WinSDK
func readRawInput() -> String? {
    let handle = GetStdHandle(STD_INPUT_HANDLE)
    var oldMode: DWORD = 0
    guard GetConsoleMode(handle, &oldMode) else { return nil }
    let newMode: UInt32 = oldMode & ~UInt32((ENABLE_LINE_INPUT | ENABLE_ECHO_INPUT))
    guard SetConsoleMode(handle, newMode) else { return nil }
    defer { SetConsoleMode(handle, oldMode) }
    var buffer: [WCHAR] = [0]
    var charsRead: DWORD = 0
    let success = ReadConsoleW(handle, &buffer, 1, &charsRead, nil)
    if success && charsRead > 0 {
        return String(buffer[0])
    } else {
        return nil
    }
}
#else
// Linux and MacOS way of reading from the commandline.
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
#endif


func readInput() -> String {
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
                    for _ in input {
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
                    for _ in input {
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
                print(sCharacter!, terminator: "")
                input += sCharacter!
            }
            fflush(stdout)
        }
    }

    return input
}
