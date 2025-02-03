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
            let sCharacter = String(cString: cCharacter)
            switch sCharacter {
            case "\r":
                continueReading = false
            default:
                input += sCharacter
            }
        }
    }

    return input
}

