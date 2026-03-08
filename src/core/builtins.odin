package core

import "core:fmt"
import "core:os"
import "core:strings"
import "../types"

Builtin_Proc :: proc(args: []string, state: ^types.Session_State)

get_builtin :: proc(name: string) -> (Builtin_Proc, bool) {
	switch name {
	case "cd":
		return builtin_cd, true
	case "exit":
		return builtin_exit, true
	case "alias":
		return builtin_alias, true
	}
	return nil, false
}

builtin_cd :: proc(args: []string, state: ^types.Session_State) {
	if len(args) == 1 {
		err := os.chdir(state.home_dir)
		if err == nil {
			state.cur_dir = state.home_dir
		} else {
			fmt.println("Failed to go home.")
			cwd, cwd_err := os.get_working_directory(context.temp_allocator)
			if cwd_err == nil {
				state.cur_dir = strings.clone(cwd)
			}
		}
		return
	}

	switch args[1] {
	case "~":
		os.chdir(state.home_dir)
		state.cur_dir = state.home_dir
	case "..":
		parts := strings.split(state.cur_dir, "/", allocator = context.temp_allocator)
		if len(parts) > 1 {
			new_dir := strings.join(parts[:len(parts) - 1], "/", context.temp_allocator)
			if len(new_dir) == 0 do new_dir = "/"
			if os.chdir(new_dir) == nil {
				state.cur_dir = strings.clone(new_dir)
			}
		}
	case "/":
		os.chdir(args[1])
		cwd, err := os.get_working_directory(context.temp_allocator)
		if err == nil {
			state.cur_dir = strings.clone(cwd)
		}
	case:
		new_dir := strings.concatenate({state.cur_dir, "/", args[1]}, context.temp_allocator)
		if os.chdir(new_dir) == nil {
			state.cur_dir = strings.clone(new_dir)
		}
	}
}

builtin_exit :: proc(args: []string, state: ^types.Session_State) {
	state.cont = false
}

builtin_alias :: proc(args: []string, state: ^types.Session_State) {
	if len(args) < 3 do return

	alias_args := make([dynamic]string)
	for a in args[2:] {
		append(&alias_args, strings.clone(a))
	}

	state.aliases[strings.clone(args[1])] = types.Command {
		command   = strings.clone(args[2]),
		arguments = alias_args[:],
	}
}
