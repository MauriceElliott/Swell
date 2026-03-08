package core

import "core:fmt"
import "core:os"
import "../types"

spawn_process :: proc(command: string, arguments: []string, state: ^types.Session_State) {
	if len(command) == 0 do return

	process, start_err := os.process_start(os.Process_Desc{
		command = arguments,
		stdin   = os.stdin,
		stdout  = os.stdout,
		stderr  = os.stderr,
	})
	if start_err != nil {
		fmt.eprintfln("Failed to spawn process, error: %v", start_err)
		return
	}

	_, wait_err := os.process_wait(process)
	if wait_err != nil {
		fmt.eprintfln("Failed to wait for process, error: %v", wait_err)
	}
}
