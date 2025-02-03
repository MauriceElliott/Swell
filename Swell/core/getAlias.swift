
func getAlias(cmd: inout Command) {
    let alias = _session.aliases[(cmd.arguments[0])]
    if (alias != nil) {
        cmd.command = alias!.command
        if (cmd.arguments.count > 1) {
            let remainingArgs = cmd.arguments[1...]
            cmd.arguments = alias!.arguments + remainingArgs
        } else {
            cmd.arguments = alias!.arguments
        }
    }
}

