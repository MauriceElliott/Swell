import Foundation

func getPrompt() -> String {
    let currentDirectory = FileManager.default.currentDirectoryPath
    let directoryFromHome = currentDirectory.replacingOccurrences(of: _session.homeDir, with: "~/")
    return directoryFromHome
}
