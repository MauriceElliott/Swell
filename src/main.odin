package main

import "config"
import "core"
import "core:fmt"
import "core:mem"
import "io"
import "parser"

main :: proc() {
	// Allocators
	program_memory := make([]byte, 8 * mem.Megabyte)
	prompt_memory := make([]byte, 1 * mem.Megabyte)
	program_arena: mem.Arena
	prompt_arena: mem.Arena
	mem.arena_init(&program_arena, program_memory)
	mem.arena_init(&prompt_arena, prompt_memory)
	context.allocator = mem.arena_allocator(&program_arena)

	defer mem.arena_free_all(&program_arena) // Clear when exit is called.

	state := config.init_session_state() //Corrent
	config.load_configuration(&state) //Correct

	//Prompt Allocator
	// Used while the current prompt is active, free'd after each "return key"
	context.allocator = mem.arena_allocator(&prompt_arena)
	for state.cont {
		defer mem.arena_free_all(&prompt_arena)
		prompt_str := core.get_prompt(&state) //Correct
		fmt.print(prompt_str)
		io.flush_stdout()

		input := io.handle_input(&state, prompt_str) //Correct
		node := parser.parse(input) //Correct
		core.evaluate(node, &state)
		io.flush_stdout()
	}
}
