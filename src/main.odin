package main

import "config"
import "core"
import "core:fmt"
import "core:mem"
import "io"
import "parser"

main :: proc() {
	program_memory := make([]byte, 8 * mem.Megabyte)
	prompt_memory := make([]byte, 1 * mem.Megabyte)
	program_arena: mem.Arena
	prompt_arena: mem.Arena
	mem.arena_init(&program_arena, program_memory)
	mem.arena_init(&prompt_arena, prompt_memory)

	// Program Allocator
	// Used while Swell is running, memory is free'd when exit is called.
	context.allocator = mem.arena_allocator(&program_arena)
	defer mem.arena_free_all(&program_arena)

	state := config.init_session_state()
	config.load_configuration(&state)

	// Prompt Allocator
	// Used while the current prompt is active, free'd after each "return key"
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
