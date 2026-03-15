package shell_io

import "../types"

handle_input :: proc(session: ^types.Session_State, prompt_str: string) -> string {
	prompt := types.Prompt_State {
		prompt        = prompt_str,
		content       = "",
		cursor_pos    = len(prompt_str),
		history_index = len(session.history),
	}

	registry := init_handler_registry()

	action := types.Input_Action.Continue_Reading
	for action == .Continue_Reading {
		input, ok := read_raw_input()
		if ok {
			handler := get_handler(&registry, input)
			action = handler(input, &prompt, session)
		}
		flush_stdout()
	}

	return prompt.content
}

