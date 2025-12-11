enum InputAction {
	case continueReading
    case readHistory
	case submitInput
}

typealias InputHandler = (
	_ sequence: String,
	_ prompt: inout PromptState,
	_ session: borrowing SessionState,
) -> InputAction

class HandlerRegistry {
	private var handlers: [String: InputHandler ]
	init() {
		self.handlers = [:]
		self.register(sequence: "\r", handler: handleEnter)
		self.register(sequence: "\u{7F}", handler: handleBackspace)
		self.register(sequence: "\u{1B}", handler: handleArrowKey)
		self.register(sequence: "\t", handler: handleTab)
	}
	func register(sequence: String, handler: @escaping InputHandler) {
		handlers[sequence] = handler
	}
	func get(sequence: String) -> InputHandler {
		if let handler = handlers[sequence] {
			return handler
		}
		return handleDefault
	}
}
