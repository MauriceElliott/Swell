import Foundation

class ConfigManager {
	let fm = FileManager.default
	func getFileDirectory(_ homeDir: String) -> String {
		let main = "\(homeDir)/.config/swell/config.swell"
		let backup = "\(homeDir)/swell/config.swell"

		if self.fm.fileExists(atPath: main) {
			return main;
		} else if self.fm.fileExists(atPath: backup) {
			return backup;
		} else {
			if let data = "echo Hello World".data(using: .utf8) {
				let b64String = data.base64EncodedData()
				_ = self.fm.createFile(atPath: main, contents: b64String)
			}
			return main;
		}
	}
	func load(state: SessionState) {
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
				evaluate(node: node)
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
		let newSession = SessionState(
			environment: env,
			homeDirectory: homeDir,
			currentDirectory: currentDir
		)

		return newSession
	}
}
