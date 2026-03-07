import core/session_state

type
  BuiltInCommand* = ref object of RootObj
    name*: string

method run*(self: BuiltInCommand, args: seq[string],
    state: SessionState) {.base.} =
  discard
