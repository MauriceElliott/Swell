struct ExitCommand: BuiltInCommand {
	let name = "exit"
	func run(args: [String], state: inout SessionState) {
		state.cont = false
	}
}
