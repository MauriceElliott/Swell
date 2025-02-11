import Foundation

func getAvailableCommands() -> [String] {
    var commands: [String] = []
    let path = ProcessInfo.processInfo.environment["PATH"] ?? ""
    let pathDirectories = path.split(separator: ":").map { String($0) }
    for dir in pathDirectories {
        let contents = try? FileManager.default.contentsOfDirectory(atPath: dir)
        if contents == nil { continue }
        for content in contents! {
            let splitContent = content.split(separator: "/").map { String($0) }
            commands.append(splitContent.last!)
        }
    }
    return commands
}
