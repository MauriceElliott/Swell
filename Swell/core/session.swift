import Foundation

struct Session {
    let homeDir = FileManager.default.homeDirectoryForCurrentUser.path()
    var currentDir = FileManager.default.currentDirectoryPath
    var aliases: [String: Command] = [:]
}
