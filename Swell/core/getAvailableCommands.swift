import Foundation

func getAvailableCommands() -> [String] {
    var commands: [String] = []
    let path = ProcessInfo.processInfo.environment["PATH"] ?? ""
    if path == "" {
        print("Error: PATH environment variable not set")
    }
    let pathDirectories = path.split(separator: ":").map { String($0) }
    for dir in pathDirectories {
        let contents = try? FileManager.default.contentsOfDirectory(atPath: dir)
        for content in contents! {
            commands.append(content)
        }
    }
    return commands
}
