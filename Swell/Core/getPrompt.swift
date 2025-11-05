import Foundation

func getPrompt(state: borrowing SessionState) -> String {
    let currentDirectory = FileManager.default.currentDirectoryPath
    let directoryFromHome = currentDirectory.replacingOccurrences(of: state.homeDir, with: "~/")
    return "\u{001B}[3;32m 󰶟  \(directoryFromHome) => \u{001B}[0;39m"
}
