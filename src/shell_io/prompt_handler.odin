package shell_io

import "../types"

handle_input :: proc(state: ^types.Session_State, prompt_str: string) -> string {
	prompt := types.Prompt_State {
		prompt        = prompt_str,
		content       = "",
		cursor_pos    = 0,
		history_index = 0,
	}

	registry := init_handler_registry()

	action := types.Input_Action.Continue_Reading
	for action == .Continue_Reading {
		input, ok := read_raw_input()
		if ok {
			handler := get_handler(&registry, input)
			action = handler(input, &prompt, state)
		}
		flush_stdout()
	}

	return prompt.content
}
