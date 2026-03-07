import tables
import builtins/builtin_command
import core/session_state

type
  AliasCommand* = ref object of BuiltInCommand

proc newAliasCommand*(): AliasCommand =
  AliasCommand(name: "alias")

method run*(self: AliasCommand, args: seq[string], state: SessionState) =
  state.aliases[args[1]] = (command: args[2], arguments: args[2 .. ^1])
