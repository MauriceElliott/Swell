//
//  main.swift
//  Swell
//
//  Created by Maurice Elliott on 19/01/2025.
//

import Foundation

var runSwell = true

while runSwell {
    print("\u{001B}[3;32m 󰶟 => \u{001B}[0;39m", terminator: "")
    let input = sanitiseInput(input: readLine())
    if input != nil {
        if input![0] == "exit" {
            runSwell = false
        } else {
            let cmd = input![0]
            let args = input!
            spawnProcess(command: cmd, arguments: args)
        }
    }
}

func sanitiseInput(input: String?) -> [String]? {

  let splitInput = input!.split(separator: " ")

  
}

func spawnProcess(command: String, arguments: [String]) {
  let path = command
  let arguments = arguments
  //convert to argument that is readable by the C command.
  var argv = arguments.map { strdup($0) }

  // Null-terminate the array
  argv.append(nil)

  // Env variables
  var envp: [UnsafeMutablePointer<CChar>?] = [nil]
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
}
