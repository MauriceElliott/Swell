enum InputAction {
	case continueReading
    case readHistory
	case submitInput
}

typealias InputHandler = (
	_ sequence: String,
	_ prompt: inout PromptState,
) -> InputAction

class HandlerRegistry {
	private var handlers: [String: InputHandler ]
	init() {
		self.handlers = [:]
		self.register("\r", handleEnter)
	}
	func register(sequence: String, handler: InputHandler) {
		handlers[sequence] = handler
	}
	func get(sequence: String) -> InputHandler {
		if let handler = handlers[sequence] {
			return handler
		}
		return nil
	}
}
