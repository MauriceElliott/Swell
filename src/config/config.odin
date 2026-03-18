package config

import "../core"
import "../parser"
import "../types"
import "core:fmt"
import "core:os"
import "core:strings"

get_file_directory :: proc(home_dir: string) -> string {
	file_name := "config.swl"
	main_dir := strings.concatenate({home_dir, ".config/swell/"}, context.temp_allocator)
	backup_dir := strings.concatenate({home_dir, ".swell/"}, context.temp_allocator)
	main_file := strings.concatenate({main_dir, file_name}, context.allocator)
	backup_file := strings.concatenate({backup_dir, file_name}, context.allocator)

	if os.is_dir(main_dir) && os.exists(main_file) {
		return main_file
	}

	if os.is_dir(backup_dir) && os.exists(backup_file) {
		return backup_file
	}

	// Create main config directory and default file
	if !os.is_dir(main_dir) {
		err := os.make_directory_all(main_dir)
		if err != nil {
			fmt.eprintln("Failed to create directory for file.")
		}
	}

	write_err := os.write_entire_file(main_file, "echo Hello World")
	if write_err != nil {
		fmt.eprintln("Failed to initialise configuration file.")
	}

	return main_file
}

load_configuration :: proc(state: ^types.Session_State) {
	file_dir := get_file_directory(state.home_dir)

	fmt.printfln("debug filedir: %s", file_dir)

	data, read_err := os.read_entire_file(file_dir, context.temp_allocator)
	if read_err != nil {
		fmt.eprintln("error reading configuration file, must be utf8 encoded!")
		return
	}

	contents := string(data)
	if len(contents) == 0 do return

	lines := strings.split(contents, "\n", allocator = context.temp_allocator)
	for line in lines {
		if len(line) == 0 do continue
		node := parser.parse(line)
		core.evaluate(node, state)
	}
}

init_session_state :: proc() -> types.Session_State {
	home_dir: string
	home, home_err := os.user_home_dir(context.allocator)
	if home_err == nil {
		// Ensure trailing slash
		if len(home) > 0 && home[len(home) - 1] != '/' {
			home_dir = strings.concatenate({home, "/"})
			delete(home)
		} else {
			home_dir = home
		}
	} else {
		home_dir = strings.clone("/")
	}

	cur_dir, _ := os.get_working_directory(context.allocator)

	env := make(map[string]string)
	env["TERM"] = "xterm-256color"
	env["COLORTERM"] = "truecolor"

	state := types.Session_State {
		available_commands   = make([dynamic]string),
		environment          = env,
		aliases              = make(map[string]types.Command),
		home_dir             = home_dir,
		cur_dir              = cur_dir,
		history              = make([dynamic]types.Command),
		cont                 = true,
		persistent_allocator = context.allocator,
	}

	update_available_commands(&state)
	return state
}

update_available_commands :: proc(state: ^types.Session_State) {
	path_env, found := os.lookup_env("PATH", context.temp_allocator)
	if !found do return

	path_dirs := strings.split(path_env, ":", allocator = context.temp_allocator)
	for dir in path_dirs {
		entries, err := os.read_directory_by_path(dir, -1, context.temp_allocator)
		if err != nil do continue
		for entry in entries {
			append(
				&state.available_commands,
				strings.clone(entry.name, state.persistent_allocator),
			)
		}
		os.file_info_slice_delete(entries, context.temp_allocator)
	}
}
