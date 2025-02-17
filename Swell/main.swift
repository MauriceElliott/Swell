import Foundation

//test comment from within a running Swell, lets see if I can use git to commit
let fileManager = FileManager.default

typealias Command = (command: String, arguments: [String])
typealias tabCompleteResult = (command: String, tabCompleted: Bool)

var _session = Session()

var runSwell = true

readConfig()

while runSwell {
    print(getPrompt(), terminator: "")
    fflush(stdout)

    if let cmd = sanitiseInput(input: readInput()) {
        mainSwitch(cmd: getAlias(cmd: cmd))
        updateHistory(cmd: cmd)
    }
}
