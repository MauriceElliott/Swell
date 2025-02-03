import Foundation

func getPrompt() -> String {
    let currentDirectory = FileManager.default.currentDirectoryPath
    let directoryFromHome = currentDirectory.replacingOccurrences(of: _session.homeDir, with: "~/")
    return "\u{001B}[3;32m 󰶟  \(directoryFromHome) =>  \u{001B}[0;39m"
}
