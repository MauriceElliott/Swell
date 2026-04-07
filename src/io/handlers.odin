package shell_io

import "../types"
import "core:fmt"
import "core:strings"

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
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
	total_content := len(prompt.content)
	total_prompt := len(prompt.prompt)
	total_prompt_line := total_prompt + total_content
	relative_cursor_pos := total_prompt_line - prompt.cursor_pos
	if relative_cursor_pos == 0 {
		prompt.content = strings.concatenate({prompt.content, sequence}, context.allocator)
		fmt.print(sequence)
		prompt.cursor_pos += 1
		return .Continue_Reading
	} else {
		for _ in prompt.content {
			fmt.print("\x1b[D\x1b[K")
		}
		pos_in_content := prompt.cursor_pos - total_prompt

		first_half := strings.concatenate(
			{prompt.content[0:pos_in_content], sequence},
			context.allocator,
		)
		second_half := prompt.content[pos_in_content:(pos_in_content + relative_cursor_pos)]

		prompt.content = strings.concatenate({first_half, second_half}, context.allocator)
		fmt.print(prompt.content)

		prompt.cursor_pos += 1
		return .Continue_Reading
	}
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
		switch letter {
		case "B":
			dir = .Down
		case "A":
			dir = .Up
		case "D":
			dir = .Left
		case "C":
			dir = .Right
		}

		if dir == .Up || dir == .Down {
			for _ in prompt.content {
				fmt.print("\x1b[D\x1b[K")
			}
			previous := read_history(dir, prompt, session)
			prompt.content = previous
			fmt.print(prompt.content)
			prompt.cursor_pos = len(prompt.content)
		} else if dir == .Left {
			fmt.print("\x1b[1D")
			prompt.cursor_pos -= 1
		} else if dir == .Right {
			fmt.print("\x1b[1C")
			prompt.cursor_pos += 1
		}

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

	builder := strings.builder_make(context.allocator)
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
		prompt.content = strings.concatenate({prompt.content, completed}, context.allocator)
		fmt.print(completed)
	}
	return .Continue_Reading
}

tab_complete :: proc(fuzz: string, state: ^types.Session_State) -> string {
	if len(fuzz) == 0 do return ""

	words := strings.fields(fuzz, context.allocator)
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

