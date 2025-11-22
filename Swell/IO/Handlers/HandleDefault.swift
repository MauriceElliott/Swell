func handleDefault(_ sequence: String, _ prompt: inout PromptState) -> InputAction {
    print(sequence, terminator: "")
	prompt.content += sequence

	return InputAction.continueReading
}
