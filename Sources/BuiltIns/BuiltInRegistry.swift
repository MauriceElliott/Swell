class BuiltInRegistry {
	private var commands: [String: BuiltInCommand]
	init() {
		self.commands = [:]
		self.register(command: CdCommand())
		self.register(command: ExitCommand())
		self.register(command: AliasCommand())
	}
	func register(command: BuiltInCommand) {
		commands[command.name] = command
	}
	func get(name: String) -> BuiltInCommand? {
		if let cmd = commands[name] {
			return cmd
		}
		return nil
	}
}
