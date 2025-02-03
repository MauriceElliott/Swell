import Foundation

let fileManager = FileManager.default

typealias Command = (command: String, arguments: [String])

var _session = Session()

var runSwell = true

readConfig()

while runSwell {
    print(getPrompt(), terminator: "")
    let input = sanitiseInput(input: readLine())
    
    if input != nil {
        var cmd = input!
        getAlias(cmd: &cmd)
        mainSwitch(cmd: cmd)
    }
}

