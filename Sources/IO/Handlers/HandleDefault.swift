func handleDefault(_ sequence: String, _ prompt: inout PromptState, _ session: borrowing SessionState) -> InputAction {
	prompt.content += sequence
    print(sequence, terminator: "")

	return InputAction.continueReading
}
