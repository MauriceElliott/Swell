package main

import "core:fmt"
import "config"
import "core"
import "parser"
import "shell_io"

main :: proc() {
	state := config.init_session_state()
	config.load_configuration(&state)

	for state.cont {
		prompt_str := core.get_prompt(&state)
		fmt.print(prompt_str)
		shell_io.flush_stdout()

		input := shell_io.handle_input(&state, prompt_str)
		node := parser.parse(input)
		core.evaluate(node, &state)
		shell_io.flush_stdout()

		free_all(context.temp_allocator)
	}
}
