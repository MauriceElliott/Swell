import Foundation

func readConfig() -> Bool {
    let configFilePath = "\(fileManager.homeDirectoryForCurrentUser.path())/.config/swell/config.swell"
    var configFileContents = ""
    if fileManager.fileExists(atPath: configFilePath) {
        do {
            configFileContents = try String(contentsOfFile: configFilePath, encoding: .utf8)
        } catch {
            print("error reading configuration!")
        }
    }
    if !configFileContents.isEmpty {
        let parsedConfigFile = configFileContents.split(separator: "\n")
        for l in parsedConfigFile {
            let cmd = sanitiseInput(input: String(l))!
            mainSwitch(cmd: cmd)
        }
    }
    return true
}
