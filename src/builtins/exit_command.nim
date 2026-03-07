import builtins/builtin_command
import core/session_state

type
  ExitCommand* = ref object of BuiltInCommand

proc newExitCommand*(): ExitCommand =
  ExitCommand(name: "exit")

method run*(self: ExitCommand, args: seq[string], state: SessionState) =
  state.cont = false
