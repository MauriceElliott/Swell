import Foundation

func changeDirectory(arguments: [String]) {
    if (arguments.count == 1) {
        fileManager.changeCurrentDirectoryPath(_session.homeDir)
        return
    }
    if(arguments[1] == "~") {
        fileManager.changeCurrentDirectoryPath(_session.homeDir)
    } else if (arguments[1] == "..") {
        let currentDirList = _session.currentDir.split(separator: "/")
        let currentDirListLength = currentDirList.count
        let sectionToRemove = currentDirList[currentDirListLength-1]
        let newDir = _session.currentDir.replacingOccurrences(of: sectionToRemove, with: "")
        fileManager.changeCurrentDirectoryPath(newDir)
        _session.currentDir = newDir
    } else if (arguments[1] == "/") {
        let path = arguments[1].trimmingCharacters(in: .init(charactersIn: "/"))
        let newDir = _session.currentDir + "/" + path
        fileManager.changeCurrentDirectoryPath(newDir)
        _session.currentDir = newDir
        
    } else {
        let newDir = _session.currentDir + "/" + arguments[1]
        fileManager.changeCurrentDirectoryPath(newDir)
        _session.currentDir = newDir
    }
}
