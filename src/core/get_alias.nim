import tables
import core/session_state
import models/command

proc getAlias*(cmd: Command, state: SessionState): Command =
  if state.aliases.hasKey(cmd.arguments[0]):
    var alias = state.aliases[cmd.arguments[0]]
    if cmd.arguments.len > 1:
      let remainingArgs = cmd.arguments[1 .. ^1]
      alias.arguments = alias.arguments & remainingArgs
    return alias
  return ("", @[])
