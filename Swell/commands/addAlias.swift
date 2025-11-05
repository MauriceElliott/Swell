
func addAlias(alias: [String]) {
    Session.shared.aliases[alias[1]] = Command(command: alias[2], arguments: Array(alias[2...]))
}

