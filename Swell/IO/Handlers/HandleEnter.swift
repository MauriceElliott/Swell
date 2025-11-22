func handleEnter(_ sequence: String, _ prompt: inout PromptState, _ session: borrowing SessionState) -> InputAction {
    print("\n", terminator: "")
	return InputAction.submitInput
}
