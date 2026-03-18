package parser

import "../types"
import "core:strings"

parse :: proc(input: string) -> types.AST_Node {
	if len(input) == 0 do return types.AST_Empty{}

	split_input := strings.fields(input, context.allocator)
	if len(split_input) == 0 do return types.AST_Empty{}

	command: string
	arguments: [dynamic]string
	arguments.allocator = context.allocator

	if strings.contains(split_input[0], "/") {
		command = split_input[0]
		// Faithful to Swift: gets the character at the last "/" index (which is "/")
		last_slash := strings.last_index(split_input[0], "/")
		if last_slash >= 0 {
			append(&arguments, split_input[0][last_slash:last_slash + 1])
		}
		if len(split_input) > 1 {
			for s in split_input[1:] {
				if !strings.contains(s, "/") {
					append(&arguments, s)
				}
			}
		}
	} else {
		command = split_input[0]
		for s in split_input {
			append(&arguments, s)
		}
	}

	return types.Command{command = command, arguments = arguments[:]}
}
