func handleBackspace(_ sequence: String, _ prompt: inout PromptState, _ session: borrowing SessionState) -> InputAction {
    if !prompt.content.isEmpty {
        prompt.content.removeLast()
        print("\u{1B}[1D\u{1B}[K", terminator: "")
    }

 	return InputAction.continueReading
}
