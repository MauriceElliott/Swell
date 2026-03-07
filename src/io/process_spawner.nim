import posix, tables
import core/session_state

proc spawnProcess*(command: string, arguments: seq[string],
    state: SessionState) =
  let path = command.cstring

  # Build argv and envp using allocCStringArray (null-terminated)
  var envStrings: seq[string] = @[]
  for key, val in state.environment:
    envStrings.add(key & "=" & val)

  let argv = allocCStringArray(arguments)
  let envp = allocCStringArray(envStrings)

  var fileActions: Tposix_spawn_file_actions
  discard posix_spawn_file_actions_init(fileActions)

  var processAttributes: Tposix_spawnattr
  discard posix_spawnattr_init(processAttributes)

  var pid: Pid
  let spawnResult = posix_spawnp(pid, path, fileActions, processAttributes,
      argv, envp)

  if spawnResult == 0:
    var status: cint = 0
    let waitResult = waitpid(pid, status, 0)
    if waitResult != pid:
      echo "Failed to wait for the process, error code: ", waitResult
  else:
    echo "Failed to spawn process, error code: ", spawnResult

  deallocCStringArray(argv)
  deallocCStringArray(envp)
  discard posix_spawn_file_actions_destroy(fileActions)
  discard posix_spawnattr_destroy(processAttributes)
