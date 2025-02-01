import Foundation

var runSwell = true
typealias Command = (command: String, arguments: [String])
_ = initConfig()

while runSwell {
    print("\u{001B}[3;32m 󰶟  \(getPrompt()) => \u{001B}[0;39m", terminator: "")
    let inputa = sanitiseInput(input: readLine())
    
    if inputa != nil {
        var cmd = inputa!
        let alias = _aliases[(cmd.arguments[0])]
        if (alias != nil){
            cmd.command = alias!.command
            if (cmd.arguments.count > 1) {
                let remainingArgs = cmd.arguments[1...]
                cmd.arguments = alias!.arguments + remainingArgs
            }
        }
        switch cmd.command {
        case "exit":
            runSwell = false;
        case "cd":
            changeDirectory(arguments: cmd.arguments)
        default:
            spawnProcess(command: cmd.command, arguments: cmd.arguments)
        }
    }
}

