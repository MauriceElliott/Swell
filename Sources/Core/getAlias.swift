
func getAlias(cmd: Command, state: SessionState) -> Optional<Command> {
    if let alias = state.aliases[(cmd.arguments[0])] {
        var command = alias
        if (cmd.arguments.count > 1) {
            let remainingArgs = cmd.arguments[1...]
            command.arguments = alias.arguments + remainingArgs
        } else {
            command.arguments = alias.arguments
        }
        return command
    }
    return nil
}
