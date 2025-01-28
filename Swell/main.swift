//
//  main.swift
//  Swell
//
//  Created by Maurice Elliott on 19/01/2025.
//

import Foundation

// Needed this for testing as it makes some things work I wanted for testing.
let env: [String: String] = [
    "TERM": "xterm-256color",
    "COLORTERM": "truecolor",
]

var runSwell = true
typealias Command = (command: String, arguments: [String])

while runSwell {
    print("\u{001B}[3;32m 󰶟  \(getPSD()) => \u{001B}[0;39m", terminator: "")
    let inputa = sanitiseInput(input: readLine())
    
    if inputa != nil {
        let cmd = inputa!
        switch cmd.command {
        case "exit":
            runSwell = false;
        case "cd":
            changeDirectory(arguments: cmd.arguments)
        default:    
            spawnProcess(command: cmd.command, arguments: cmd.arguments)
        }
    }
}

func getPSD() -> String {
    let currentDirectory = FileManager.default.currentDirectoryPath
    let homeDirectory = FileManager.default.homeDirectoryForCurrentUser.path()
    let directoryFromHome = currentDirectory.replacingOccurrences(of: homeDirectory, with: "~/")
    return directoryFromHome
}

func sanitiseInput(input: String?) -> Command? {
    if input == "" { return nil }
    
    let splitInput = input!.split(separator: " ").map { String($0) }
    var command = ""
    var arguments = [""]
    if splitInput[0].contains("/") {
        command = String(splitInput[0])
        arguments = [splitInput[0].substring(from: splitInput[0].lastIndex(of: "/")!)]
        if splitInput.count > 1 {
            arguments.append(contentsOf: splitInput.filter { $0.contains("/") == false })
        }
    } else {
        command = splitInput[0]
        arguments = splitInput
    }
    return (command, arguments)
}

func spawnProcess(command: String, arguments: [String]) {
    let path = command
    let arguments = arguments
    //convert to argument that is readable by the C command.
    var argv = arguments.map { strdup($0) }
    
    // Null-terminate the array
    argv.append(nil)
    
    // Env variables
    var envp: [UnsafeMutablePointer<CChar>?] =
    env.map { strdup("\($0)=\($1)") } + [nil]
    envp.append(nil)
    
    // Define file actions
    var fileActions: posix_spawn_file_actions_t?
    posix_spawn_file_actions_init(&fileActions)
    
    // Define process attributes
    var processAttributes: posix_spawnattr_t?
    posix_spawnattr_init(&processAttributes)
    
    // Call posix_spawnp
    var pid: pid_t = 0
    let spawnResult = posix_spawnp(&pid, path, &fileActions, &processAttributes, argv, envp)
    
    if spawnResult == 0 {
        var status: Int32 = 0
        let waitResult = waitpid(pid, &status, 0)
        
        if waitResult != pid {
            print("Failed to wait for the process, error code: \(waitResult)")
        }
    } else {
        print("Failed to spawn process, error code: \(spawnResult)")
    }
    
    for arg in argv {
        free(arg)
    }
    posix_spawn_file_actions_destroy(&fileActions)
    posix_spawnattr_destroy(&processAttributes)
}

func changeDirectory(arguments: [String]) {
    if(arguments[1] == "~") {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.path()
        FileManager.default.changeCurrentDirectoryPath(homeDir)
    }
}

