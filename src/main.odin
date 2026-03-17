package main

import "config"
import "core"
import "core:fmt"
import "io"
import "mem"
import "parser"

main :: proc() {
	// Session Allocator
	program_arena: mem.Arena
	mem.arena_init(&program_arena, 8 * mem.MEGABYTE)
	defer mem.arena_free_all(&program_arena) // Clear when exit is called.
	context.allocator = mem.arena_allocator(&program_arena) //use arena as the default allocator

	state := config.init_session_state()
	config.load_configuration(&state)

	//Prompt Allocator
	// Used while the current prompt is active, free'd after each "return key"
	prompt_arena: mem.Arena
	mem.arena_init(&prompt_arena, 1 * mem.MEGABYTE)
	context.allocator = mem.arena_allocator(&prompt_arena)

	for state.cont {
		defer mem.arena_free_all(&prompt_arena)
		prompt_str := core.get_prompt(&state)
		fmt.print(prompt_str)
		io.flush_stdout()

		input := io.handle_input(&state, prompt_str)
		node := parser.parse(input)
		core.evaluate(node, &state)
		io.flush_stdout()
	}
}

