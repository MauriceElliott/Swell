import os, strutils
import builtins/builtin_command
import core/session_state

type
  CdCommand* = ref object of BuiltInCommand

proc newCdCommand*(): CdCommand =
  CdCommand(name: "cd")

method run*(self: CdCommand, args: seq[string], state: SessionState) =
  if args.len == 1:
    try:
      setCurrentDir(state.homeDir)
      state.curDir = state.homeDir
    except OSError:
      echo "Failed to go home."
      state.curDir = getCurrentDir()
  else:
    case args[1]
    of "~":
      try:
        setCurrentDir(state.homeDir)
      except OSError:
        discard
      state.curDir = state.homeDir
    of "..":
      let currentDirList = state.curDir.split('/')
      if currentDirList.len > 0:
        let sectionToRemove = currentDirList[^1]
        let newDir = state.curDir.replace("/" & sectionToRemove, "")
        try:
          setCurrentDir(newDir)
          state.curDir = newDir
        except OSError:
          discard
      else:
        state.curDir = getCurrentDir()
    of "/":
      try:
        setCurrentDir(args[1])
      except OSError:
        discard
      state.curDir = getCurrentDir()
    else:
      let newDir = state.curDir & "/" & args[1]
      try:
        setCurrentDir(newDir)
        state.curDir = newDir
      except OSError:
        discard
