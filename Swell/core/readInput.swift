import Foundation
import Darwin

func readInput() -> String {
    //Set terminal to take raw input (this means you don't need to wait for an enter to parse the typed input)
    var input = ""

    var continueReading = true
    
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
            //required due to stdout not printing while in raw mode
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
            default:
                print(sCharacter, terminator: "")
                input += sCharacter
            }
            fflush(stdout)
        }
    }

    return input
}

