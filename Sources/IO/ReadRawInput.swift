import Foundation

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

