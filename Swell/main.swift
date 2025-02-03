import Foundation

var runSwell = true
typealias Command = (command: String, arguments: [String])
_ = readConfig()

while runSwell {
    print(getPrompt(), terminator: "")
    let input = sanitiseInput(input: readLine())
    
    if input != nil {
        var cmd = input!
        getAlias(cmd: &cmd)
        mainSwitch(cmd: cmd)
    }
}

