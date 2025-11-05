
func getAlias(cmd: Command) -> Command {
    let alias = Session.shared.aliases[(cmd.arguments[0])]
    var command = cmd;
    if (alias != nil) {
        command.command = alias!.command
        if (cmd.arguments.count > 1) {
            let remainingArgs = cmd.arguments[1...]
            command.arguments = alias!.arguments + remainingArgs
        } else {
            command.arguments = alias!.arguments
        }
    }
    return command
}

