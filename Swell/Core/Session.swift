import Foundation

class Session {
    static let shared = Session()
    var availableCommands: [String]
    let configFilePath: String
    var aliases: [String: Command]
    let homeDir: String
    var currentDir: String
    var history: [Command]
    var historyIndex: Int
    var lastKeyPressed: String

    private init() {
        self.availableCommands = getAvailableCommands()
        self.homeDir = FileManager.default.homeDirectoryForCurrentUser.path()
        self.configFilePath = "\(self.homeDir)/.config/swell/config.swell"
        self.currentDir = FileManager.default.currentDirectoryPath
        self.aliases = [:]
        self.history = []
        self.historyIndex = 0
        self.lastKeyPressed = ""
    }
    public func update() {
        self.currentDir = FileManager.default.currentDirectoryPath
    }
}
