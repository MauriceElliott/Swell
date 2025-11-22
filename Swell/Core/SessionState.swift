class SessionState {
	var availableCommands: [String]
	var environment: [String: String]
    var aliases: [String: Command]
    let homeDir: String
    var curDir: String
    var history: [Command]
	var cont: Bool
    internal init(
		environment: [String: String],
		homeDirectory: String,
		currentDirectory: String
	) {
		self.availableCommands = []
		self.environment = environment
        self.homeDir = homeDirectory
        self.curDir = currentDirectory
        self.aliases = [:]
        self.history = []
		self.cont = true
    }
}
