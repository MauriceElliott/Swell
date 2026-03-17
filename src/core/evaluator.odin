package core

import "core:strings"
import "../types"

evaluate :: proc(node: types.AST_Node, state: ^types.Session_State) {
	switch v in node {
	case types.Command:
		if run, ok := get_builtin(v.command); ok {
			run(v.arguments, state)
		} else {
			if aliased, alias_ok := get_alias(v, state); alias_ok {
				spawn_process(aliased.command, aliased.arguments, state)
			}
			spawn_process(v.command, v.arguments, state)
		}
		append(&state.history, clone_command(v, state.persistent_allocator))

	case types.Pipeline:
		for n in v.nodes {
			evaluate(n, state)
		}
	case types.AST_Empty:
		// Nothing to do
	case:
		spawn_process("", {""}, state)
	}
}

clone_command :: proc(cmd: types.Command, allocator := context.allocator) -> types.Command {
	args := make([]string, len(cmd.arguments), allocator)
	for i := 0; i < len(cmd.arguments); i += 1 {
		args[i] = strings.clone(cmd.arguments[i], allocator)
	}
	return types.Command {
		command   = strings.clone(cmd.command, allocator),
		arguments = args,
	}
}
