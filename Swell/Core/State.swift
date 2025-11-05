// MauriceElliott 05/11/2025
// Rewrite
// The state of the current shell session

class SessionState {
	var environment: [String: String]
    var aliases: [String: Command]
    let homeDir: String
    var curDir: String
    var history: [Command]
    var historyIndex: Int

    internal init(
		environment: [String: String],
		homeDirectory: String,
		currentDirectory: String
	) {
		self.environment = environment
        self.homeDir = homeDirectory
        self.curDir = currentDirectory
        self.aliases = [:]
        self.history = []
        self.historyIndex = 0
    }
}
