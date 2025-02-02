import Foundation

var runSwell = true
typealias Command = (command: String, arguments: [String])
_ = readConfig()

while runSwell {
    print("\u{001B}[3;32m 󰶟  \(getPrompt()) => \u{001B}[0;39m", terminator: "")
    let input = sanitiseInput(input: readLine())
    
    if input != nil {
        var cmd = input!
        let alias = _aliases[(cmd.arguments[0])]
        if (alias != nil) {
            cmd.command = alias!.command
            if (cmd.arguments.count > 1) {
                let remainingArgs = cmd.arguments[1...]
                cmd.arguments = alias!.arguments + remainingArgs
            } else {
                cmd.arguments = alias!.arguments
            }
        }
        switch cmd.command {
        case "exit":
            runSwell = false;
        case "cd":
            changeDirectory(arguments: cmd.arguments)
        case "alias":
            addAlias(alias: cmd.arguments)
        default:
            spawnProcess(command: cmd.command, arguments: cmd.arguments)
        }
    }
}

