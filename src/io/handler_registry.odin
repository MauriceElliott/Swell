package shell_io

import "../types"

Handler_Registry :: struct {
	handlers: map[string]types.Input_Handler,
}

init_handler_registry :: proc() -> Handler_Registry {
	handlers := make(map[string]types.Input_Handler, 8, context.allocator)
	handlers["\r"] = handle_enter
	handlers["\x7F"] = handle_backspace
	handlers["\x1b"] = handle_arrow_key
	handlers["\t"] = handle_tab
	return Handler_Registry{handlers = handlers}
}

get_handler :: proc(reg: ^Handler_Registry, sequence: string) -> types.Input_Handler {
	if handler, ok := reg.handlers[sequence]; ok {
		return handler
	}
	return handle_default
}
