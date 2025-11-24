struct AliasCommand: BuiltInCommand {
	let name: String = "alias"
	func run(args: [String], state: inout SessionState) {
		state.aliases[args[1]] = Command(command: args[2], arguments: Array(args[2...]))
	}
}
