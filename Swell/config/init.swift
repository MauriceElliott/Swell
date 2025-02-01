var _aliases: [String: Command] = [:]

func initConfig() -> Bool {
    _aliases["ll"] = ("ls", ["ls", "-lA"])
    return true
}
