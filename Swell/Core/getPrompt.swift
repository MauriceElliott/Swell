import Foundation

func getPrompt(state: borrowing SessionState) -> String {
    let directoryFromHome = state.curDir.replacingOccurrences(of: state.homeDir, with: "~/")
    return "\u{001B}[3;32m 󰶟  \(directoryFromHome) => \u{001B}[0;39m"
}
