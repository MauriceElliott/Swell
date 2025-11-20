func handleEnter(_ seqence: String, _ prompt: inout PromptState) -> InputAction {
    print("\n", terminator: "")
	return InputAction.submitInput
}
