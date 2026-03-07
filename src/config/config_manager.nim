import os, tables, strutils
import core/session_state
import core/evaluator
import parser/parser

proc directoryExists(path: string): bool =
  dirExists(path)

proc getFileDirectory*(homeDir: string): string =
  let main = homeDir & ".config/swell/"
  let backup = homeDir & ".swell/"
  let fileName = "config.swell"
  let backupFile = backup & fileName
  let mainFile = main & fileName

  if directoryExists(main) and fileExists(mainFile):
    return mainFile
  elif directoryExists(backup) and fileExists(backupFile):
    return backupFile
  else:
    if not directoryExists(main):
      try:
        createDir(main)
      except OSError:
        echo "Failed to create directory for file."
    try:
      writeFile(mainFile, "echo Hello World")
    except IOError:
      echo "Failed to initialise configuration file."
    return mainFile

proc loadConfiguration*(state: SessionState) =
  let fileDir = getFileDirectory(state.homeDir)
  echo "debug filedir: ", fileDir
  var configFileContents = ""
  try:
    configFileContents = readFile(fileDir)
  except IOError:
    echo "error reading configuration file, must be utf8 encoded!"
  if configFileContents.len > 0:
    let parsedConfigFile = configFileContents.split('\n')
    for l in parsedConfigFile:
      if l.strip().len > 0:
        let node = parse(l)
        evaluate(node, state)

proc updateAvailableCommands*(state: SessionState) =
  var commands: seq[string] = @[]
  let pathEnv = getEnv("PATH", "")
  let pathDirectories = pathEnv.split(':')
  for dir in pathDirectories:
    if not dirExists(dir):
      continue
    for kind, path in walkDir(dir):
      if kind == pcFile or kind == pcLinkToFile:
        let (_, name, _) = splitFile(path)
        commands.add(name)
  state.availableCommands = commands

proc initSessionState*(): SessionState =
  let homeDir = getHomeDir()
  let currentDir = getCurrentDir()
  let env = {"TERM": "xterm-256color", "COLORTERM": "truecolor"}.toTable
  var newSession = newSessionState(env, homeDir, currentDir)
  updateAvailableCommands(newSession)
  return newSession
