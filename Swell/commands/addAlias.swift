
func Alias(alias: [String]) -> Command {
    return Command(command: alias[2], arguments: Array(alias[2...]))
}

