import tables
import io/handler_types
import io/input_handlers

type
  HandlerRegistry* = object
    handlers: Table[string, InputHandler]

proc newHandlerRegistry*(): HandlerRegistry =
  result.handlers = initTable[string, InputHandler]()
  result.handlers["\r"] = handleEnter
  result.handlers["\x7F"] = handleBackspace
  result.handlers["\x1B"] = handleArrowKey
  result.handlers["\t"] = handleTab

proc get*(registry: HandlerRegistry, sequence: string): InputHandler =
  if registry.handlers.hasKey(sequence):
    return registry.handlers[sequence]
  return handleDefault
