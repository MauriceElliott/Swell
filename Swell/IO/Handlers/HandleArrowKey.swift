enum direction {
    case up
    case down
}

func handleArrowKey(_ sequence: String, _ prompt: inout PromptState, _ session: borrowing SessionState) -> InputAction {
	let sb = readRawInput()
	if sb == "[" {
		let letter = readRawInput()
		let direction = letter == "B" ? direction.down : direction.up
        for _ in prompt.content {
            print("\u{1B}[D\u{1B}[K", terminator: "")
        }
        let previousHistory = readHistory(direction: direction, prompt: &prompt, session: session)
        prompt.content = previousHistory
        print(prompt.content, terminator: "")
	}
	return InputAction.continueReading
}

func readHistory(direction: direction, prompt: inout PromptState, session: borrowing SessionState) -> String {
    if (prompt.historyIndex < 0) {
        prompt.historyIndex = 0
    } else if (prompt.historyIndex >= session.history.count) {
        prompt.historyIndex = session.history.count - 1
    }
    let entry = session.history[prompt.historyIndex]
    var result = ""
    for arg in entry.arguments {
        result += arg + " "
    }
    prompt.historyIndex = direction == .up ? prompt.historyIndex - 1: prompt.historyIndex + 1;
    return result
}

