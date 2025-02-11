import Foundation

func changeDirectory(arguments: [String]) {
    if arguments.count == 1 {
        fileManager.changeCurrentDirectoryPath(_session.homeDir)
        _session.currentDir = _session.homeDir
        return
    }
    switch arguments[1] {
    case "~":
        fileManager.changeCurrentDirectoryPath(_session.homeDir)
    case "..":
        let currentDirList = _session.currentDir.split(separator: "/")
        if let sectionToRemove = currentDirList.last {
            let newDir = _session.currentDir.replacingOccurrences(of: "/\(sectionToRemove)", with: "")
            fileManager.changeCurrentDirectoryPath(newDir)
            _session.currentDir = newDir
        }
    case "/":
        fileManager.changeCurrentDirectoryPath("/")
        _session.currentDir = "/"
    default:
        let newDir = _session.currentDir + "/" + arguments[1]
        fileManager.changeCurrentDirectoryPath(newDir)
        _session.currentDir = newDir
    }
}
