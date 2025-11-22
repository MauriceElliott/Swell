func handleTab(_ sequence: String, _ prompt: inout PromptState, _ session: borrowing SessionState) -> InputAction {
    let completed = tabComplete(fuzz: prompt.content, state: session)
    if completed != prompt.content {
        prompt.content += completed
        print(completed, terminator: "")
    }

	return InputAction.continueReading
}

func tabComplete(fuzz: String, state: borrowing SessionState) -> String {
    if fuzz.count == 0 {
        return ""
    }
    if fuzz.split(separator: " ").count == 1 && fuzz.last != " " {
        let startsWith = state.availableCommands.filter{$0.starts(with: fuzz)}
        if(startsWith.count > 0) {
            return startsWith.first!.replacingOccurrences(of: fuzz, with: "")
        }
    } else if fuzz.split(separator: " ").count > 1 || fuzz.last == " " {
        //to be continued, this needs to autocomplete paths
    }
    
    return fuzz
}
