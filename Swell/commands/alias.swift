
var _aliases: [String: Command] = [:]
func addAlias(alias: [String]) {
    for a in alias {
        print(a)
    }
    _aliases[alias[1]] = Command(command: alias[2], arguments: Array(alias[2...]))
}
