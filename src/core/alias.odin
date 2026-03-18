package core

import "../types"

get_alias :: proc(cmd: types.Command, state: ^types.Session_State) -> (types.Command, bool) {
	if len(cmd.arguments) == 0 do return {}, false

	alias, found := state.aliases[cmd.arguments[0]]
	if !found do return {}, false

	result := alias
	if len(cmd.arguments) > 1 {
		combined := make([dynamic]string, context.allocator)
		for a in alias.arguments {
			append(&combined, a)
		}
		for a in cmd.arguments[1:] {
			append(&combined, a)
		}
		result.arguments = combined[:]
	}

	return result, true
}
