import Foundation
let configFilePath = "\(fileManager.homeDirectoryForCurrentUser.path())/.config/swell/config.swell"

func readConfig() {
    var configFileContents = ""
    if fileManager.fileExists(atPath: configFilePath) {
        do {
            configFileContents = try String(contentsOfFile: configFilePath, encoding: .utf8)
        } catch {
            print("error reading configuration file, must be utf8 encoded!")
        }
    }
    if !configFileContents.isEmpty {
        let parsedConfigFile = configFileContents.split(separator: "\n")
        for l in parsedConfigFile {
            let cmd = sanitiseInput(input: String(l))!
            mainSwitch(cmd: cmd)
        }
    }
}
