package shell_io

import "core:fmt"
import "core:strings"
import "../types"

Direction :: enum {
	Up,
	Down,
}

handle_enter :: proc(
	sequence: string,
	prompt: ^types.Prompt_State,
	session: ^types.Session_State,
) -> types.Input_Action {
	fmt.print("\n")
	return .Submit_Input
}

handle_backspace :: proc(
	sequence: string,
	prompt: ^types.Prompt_State,
	session: ^types.Session_State,
) -> types.Input_Action {
	if len(prompt.content) > 0 {
		prompt.content = prompt.content[:len(prompt.content) - 1]
		fmt.print("\x1b[1D\x1b[K")
	}
	return .Continue_Reading
}

handle_default :: proc(
	sequence: string,
	prompt: ^types.Prompt_State,
	session: ^types.Session_State,
) -> types.Input_Action {
	prompt.content = strings.concatenate({prompt.content, sequence}, context.temp_allocator)
	fmt.print(sequence)
	return .Continue_Reading
}

handle_arrow_key :: proc(
	sequence: string,
	prompt: ^types.Prompt_State,
	session: ^types.Session_State,
) -> types.Input_Action {
	sb, ok := read_raw_input()
	if !ok do return .Continue_Reading

	if sb == "[" {
		letter, ok2 := read_raw_input()
		if !ok2 do return .Continue_Reading

		dir: Direction
		if letter == "B" {
			dir = .Down
		} else {
			dir = .Up
		}

		// Clear current content from display
		for _ in prompt.content {
			fmt.print("\x1b[D\x1b[K")
		}

		previous := read_history(dir, prompt, session)
		prompt.content = previous
		fmt.print(prompt.content)
	}
	return .Continue_Reading
}

read_history :: proc(
	dir: Direction,
	prompt: ^types.Prompt_State,
	session: ^types.Session_State,
) -> string {
	if len(session.history) == 0 do return ""

	if prompt.history_index < 0 {
		prompt.history_index = 0
	} else if prompt.history_index >= len(session.history) {
		prompt.history_index = len(session.history) - 1
	}

	entry := session.history[prompt.history_index]

	builder := strings.builder_make(context.temp_allocator)
	for arg in entry.arguments {
		strings.write_string(&builder, arg)
		strings.write_string(&builder, " ")
	}

	if dir == .Up {
		prompt.history_index -= 1
	} else {
		prompt.history_index += 1
	}
	return strings.to_string(builder)
}

handle_tab :: proc(
	sequence: string,
	prompt: ^types.Prompt_State,
	session: ^types.Session_State,
) -> types.Input_Action {
	completed := tab_complete(prompt.content, session)
	if completed != prompt.content {
		prompt.content = strings.concatenate({prompt.content, completed}, context.temp_allocator)
		fmt.print(completed)
	}
	return .Continue_Reading
}

tab_complete :: proc(fuzz: string, state: ^types.Session_State) -> string {
	if len(fuzz) == 0 do return ""

	words := strings.fields(fuzz, context.temp_allocator)
	if len(words) == 1 && fuzz[len(fuzz) - 1] != ' ' {
		for cmd in state.available_commands {
			if strings.has_prefix(cmd, fuzz) {
				// Return the completion suffix
				return cmd[len(fuzz):]
			}
		}
	}
	// TODO: path completion for multi-word input

	return fuzz
}
