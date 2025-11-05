import Foundation

typealias Command = (command: String, arguments: [String])
typealias tabCompleteResult = (command: String, tabCompleted: Bool)
let fileManager = FileManager.default

var runSwell = true

readConfig()

while runSwell {
    print(getPrompt(), terminator: "")
    fflush(stdout)

    if let cmd = sanitiseInput(input: readInput()) {
        mainSwitch(cmd: getAlias(cmd: cmd))
        updateHistory(cmd: cmd)
    }

    Session.shared.update()
}
