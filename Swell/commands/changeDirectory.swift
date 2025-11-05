import Foundation

func changeDirectory(arguments: [String]) {
    if arguments.count == 1 {
        _ = fileManager.changeCurrentDirectoryPath(Session.shared.homeDir)
        return
    }
    switch arguments[1] {
    case "~":
        _ = fileManager.changeCurrentDirectoryPath(Session.shared.homeDir)
    case "..":
        let currentDirList = Session.shared.currentDir.split(separator: "/")
        if let sectionToRemove = currentDirList.last {
            let newDir = Session.shared.currentDir.replacingOccurrences(of: "/\(sectionToRemove)", with: "")
            _ = fileManager.changeCurrentDirectoryPath(newDir)
            Session.shared.currentDir = newDir
        }
    case "/":
        _ = fileManager.changeCurrentDirectoryPath("/")
        Session.shared.currentDir = "/"
    default:
        let newDir = Session.shared.currentDir + "/" + arguments[1]
        _ = fileManager.changeCurrentDirectoryPath(newDir)
        Session.shared.currentDir = newDir
    }
}
