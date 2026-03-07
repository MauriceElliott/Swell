import tables
import models/command

type
  SessionState* = ref object
    availableCommands*: seq[string]
    environment*: Table[string, string]
    aliases*: Table[string, Command]
    homeDir*: string
    curDir*: string
    history*: seq[Command]
    cont*: bool

proc newSessionState*(environment: Table[string, string], homeDirectory: string,
    currentDirectory: string): SessionState =
  SessionState(
    availableCommands: @[],
    environment: environment,
    aliases: initTable[string, Command](),
    homeDir: homeDirectory,
    curDir: currentDirectory,
    history: @[],
    cont: true,
  )
