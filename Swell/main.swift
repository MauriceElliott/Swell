import Foundation

let fileManager = FileManager.default

typealias Command = (command: String, arguments: [String])

var _session = Session()

var runSwell = true

readConfig()

while runSwell {
    print(getPrompt(), terminator: "")
    var rawInput = readInput()
    if rawInput.last == "\t" {
        rawInput = tabComplete(fuzz: rawInput)
    }
    let input = sanitiseInput(input: rawInput)
    
    if input != nil {
        var cmd = input!
        getAlias(cmd: &cmd)
        mainSwitch(cmd: cmd)
    }
}
