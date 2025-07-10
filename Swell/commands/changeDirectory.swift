import Foundation

func changeDirectory(arguments: [String]) {
    if arguments.count == 1 {
        _ = fileManager.changeCurrentDirectoryPath(_session.homeDir)
        _session.currentDir = _session.homeDir
        return
    }
    switch arguments[1] {
    case "~":
        _ = fileManager.changeCurrentDirectoryPath(_session.homeDir)
    case "..":
        let currentDirList = _session.currentDir.split(separator: "/")
        if let sectionToRemove = currentDirList.last {
            let newDir = _session.currentDir.replacingOccurrences(of: "/\(sectionToRemove)", with: "")
            _ = fileManager.changeCurrentDirectoryPath(newDir)
            _session.currentDir = newDir
        }
    case "/":
        _ = fileManager.changeCurrentDirectoryPath("/")
        _session.currentDir = "/"
    default:
        let newDir = _session.currentDir + "/" + arguments[1]
        _ = fileManager.changeCurrentDirectoryPath(newDir)
        _session.currentDir = newDir
    }
}
