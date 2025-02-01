import Foundation

//this is just here for testing, should be removed once env is retrieved correctly
let env: [String: String] = [
    "TERM": "xterm-256color",
    "COLORTERM": "truecolor",
]

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
