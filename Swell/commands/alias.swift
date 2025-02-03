//in memory aliases, read in main when parsing new commands
//updated when loading config or the alias command is called.

func addAlias(alias: [String]) {
    _session.aliases[alias[1]] = Command(command: alias[2], arguments: Array(alias[2...]))
}

