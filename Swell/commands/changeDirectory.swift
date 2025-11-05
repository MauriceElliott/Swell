import Foundation

func changeDirectory(arguments: [String], state: borrowing SessionState) -> String {
    let fm = FileManager.default
    if arguments.count == 1 {
        if fm.changeCurrentDirectoryPath(state.homeDir) {
            return state.homeDir
        } else {
            print("Failed to go home.")
            return fm.currentDirectoryPath
        }
    }
    switch arguments[1] {
    case "~":
        _ = fm.changeCurrentDirectoryPath(state.homeDir)
        return state.homeDir
    case "..":
        // TODO Needs to change to recursion so in the instance that there is a second .. we can just call change directory again and have it deal with the change.
        let currentDirList = state.curDir.split(separator: "/")
        if let sectionToRemove = currentDirList.last {
            let newDir = state.curDir.replacingOccurrences(of: "/\(sectionToRemove)", with: "")
            if fm.changeCurrentDirectoryPath(newDir) {
                return newDir
            }
        } else {
            return fm.currentDirectoryPath
        }
    case "/":
        _ = fm.changeCurrentDirectoryPath(arguments[1])
        return fm.currentDirectoryPath
    default:
        let newDir = state.curDir + "/" + arguments[1]
        if fm.changeCurrentDirectoryPath(newDir) {
            return newDir
        }
    }
    return fm.currentDirectoryPath
}
