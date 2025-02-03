
func addAlias(alias: [String]) {
    _session.aliases[alias[1]] = Command(command: alias[2], arguments: Array(alias[2...]))
}

