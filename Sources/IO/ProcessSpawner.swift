import Foundation


// There are a lot of low level C functions called here
// That might be fine for the forseeable future and might just be something we leave and let live
// But I can't imagine there isn't a better way to achieve making syscalls in Swift.
// We should also have more and better validation around arguments, i.e. make command a Command input
// and then convert it to string on this side, then we don't need to split it into arguments input.
func spawnProcess(command: String, arguments: [String], state: borrowing SessionState) {
    let path = command
    let arguments = arguments
    var argv = arguments.map { strdup($0) }

    // Null-terminate the array
    argv.append(nil)

    // Env variables
    let envp: [UnsafeMutablePointer<CChar>?] = state.environment.map { strdup("\($0)=\($1)") } + [nil]

    // Define file actions
    #if os(macOS) //compilation on linux vs macos treats these values differently.
    var fileActions: posix_spawn_file_actions_t?
    #else
    var fileActions: posix_spawn_file_actions_t = posix_spawn_file_actions_t()
    #endif
    posix_spawn_file_actions_init(&fileActions)

    // Define process attributes
    #if os(macOS)
    var processAttributes: posix_spawnattr_t?
    #else
    var processAttributes: posix_spawnattr_t = posix_spawnattr_t()
    #endif

    posix_spawnattr_init(&processAttributes)

    // Call posix_spawnp
    var pid: pid_t = 0
    let spawnResult = posix_spawnp(&pid, path, &fileActions, &processAttributes, argv, envp)

    // if the process was spawned, wait for it to finish
    if spawnResult == 0 {
        var status: Int32 = 0
        let waitResult = waitpid(pid, &status, 0)
        // If the waitResult matches the pid, the process was successful.
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
