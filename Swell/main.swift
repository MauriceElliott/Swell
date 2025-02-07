import Foundation

let fileManager = FileManager.default

typealias Command = (command: String, arguments: [String])
typealias tabCompleteResult = (command: String, tabCompleted: Bool)

func clearLine() {
    print("\u{1B}[2K", terminator: "")
    print("\u{1B}[0G", terminator: "")
    fflush(stdout)
}

var _session = Session()

var runSwell = true

readConfig()

while runSwell {
    print(getPrompt(), terminator: "")
    fflush(stdout)

    var rawInput = readInput()
    let input = sanitiseInput(input: rawInput)
    
    if input != nil {
        var cmd = input!
        getAlias(cmd: &cmd)
        mainSwitch(cmd: cmd)
    }
}
