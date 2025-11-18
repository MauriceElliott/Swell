import Foundation

extension FileManager {
    func directoryExists(atPath: String) -> Bool {
  		var isDir: Bool = false
    	return fileExists(atPath: atPath, isDirectory: &isDir) && isDir
    }
}

class ConfigManager {
	let fm = FileManager.default
	func getFileDirectory(_ homeDir: String) -> String {
		let main = "\(homeDir)/.config/swell/"
		let backup = "\(homeDir)/.swell/"
		let fileName = "config.swell"
		let backupFile = "\(backup)\(fileName)"
		let mainFile = "\(main)\(fileName)"
		if fm.directoryExists(atPath: main) && fm.fileExists(atPath: mainFile) {
			return main;
		} else if fm.directoryExists(atPath: backup) && fm.fileExists(atPath: backupFile) {
			return backup;
		} else {
			if !fm.directoryExists(atPath: main) {
				do {
					_ = try fm.createDirectory(at: URL(fileURLWithPath: main), withIntermediateDirectories: true)
				} catch {
					print("Failed to create directory for file.")
				}
			}
			do {
				try "echo Hello World".write(toFile: mainFile, atomically: true, encoding: .utf8)
			} catch {
				print("Failed to initialise configuration file.")
			}
			return mainFile;
		}
	}
	func loadConfiguration(state: inout SessionState) {
		let fileDir = getFileDirectory(state.homeDir)
		var configFileContents = ""
    	do {
    	    configFileContents = try String(contentsOfFile: fileDir, encoding: .utf8)
    	} catch {
    	    print("error reading configuration file, must be utf8 encoded!")
    	}
    	if !configFileContents.isEmpty {
    	    let parsedConfigFile = configFileContents.split(separator: "\n")
    	    for l in parsedConfigFile {
    	        let node = parse(input: String(l))
				evaluate(node: node, state: &state)
    	    }
    	}
	}
	func initSessionState() -> SessionState {
		let homeDir = FileManager.default.homeDirectoryForCurrentUser.path()
		let currentDir = FileManager.default.currentDirectoryPath
		let env: [String: String] = [
		    "TERM": "xterm-256color",
		    "COLORTERM": "truecolor",
		]
		var newSession = SessionState(
			environment: env,
			homeDirectory: homeDir,
			currentDirectory: currentDir
		)

		self.updateAvailableCommands(state: &newSession)
		return newSession
	}
	func updateAvailableCommands(state: inout SessionState) {
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
	    state.availableCommands = commands
	}

}
