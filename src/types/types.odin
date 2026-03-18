package types

import "core:mem"

Command :: struct {
	command:   string,
	arguments: []string,
	raw:       string,
}

AST_Node :: union {
	AST_Empty,
	Command,
	Pipeline,
}

AST_Empty :: struct {}

Pipeline :: struct {
	nodes: [dynamic]AST_Node,
}

Prompt_State :: struct {
	prompt:        string,
	content:       string,
	cursor_pos:    int,
	history_index: int,
}

Input_Action :: enum {
	Continue_Reading,
	Read_History,
	Submit_Input,
}

Input_Handler :: proc(
	sequence: string,
	prompt: ^Prompt_State,
	session: ^Session_State,
) -> Input_Action

Session_State :: struct {
	available_commands:   [dynamic]string,
	environment:          map[string]string,
	aliases:              map[string]Command,
	home_dir:             string,
	cur_dir:              string,
	history:              [dynamic]Command,
	cont:                 bool,
	persistent_allocator: mem.Allocator,
}
