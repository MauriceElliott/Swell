package core

import "../types"
import "core:fmt"
import "core:strings"

get_prompt :: proc(state: ^types.Session_State) -> string {
	dir_from_home, _ := strings.replace_all(state.cur_dir, state.home_dir, "~/", context.allocator)
	return fmt.tprintf("\x1b[3;32m 󰶟  %s => \x1b[0;39m", dir_from_home)
}
