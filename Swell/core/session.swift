import Foundation

var _session = Session()

struct Session {
    let homeDir = FileManager.default.homeDirectoryForCurrentUser.path()
    var currentDir = FileManager.default.currentDirectoryPath
}
