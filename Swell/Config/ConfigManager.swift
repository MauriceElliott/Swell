import Foundation

extension FileManager {
    func directoryExists(atPath: String) -> Bool {
		print("debug in extension")
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
			print("debug1")
			return main;
		} else if fm.directoryExists(atPath: backup) && fm.fileExists(atPath: backupFile) {
			return backup;
		} else {
			print("debug2")
			if !fm.directoryExists(atPath: main) {
				do {
					print("debug3")
					_ = try fm.createDirectory(at: URL(fileURLWithPath: main), withIntermediateDirectories: true)				
				} catch {
					print("Failed to create directory for file.")
				}
				
			}
			if let data = "echo Hello World".data(using: .utf8) {
				let b64String = data.base64EncodedData()
				_ = self.fm.createFile(atPath: mainFile, contents: b64String)
			}
			return main;
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
