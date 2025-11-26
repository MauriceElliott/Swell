import Foundation

func handleInput(state: inout SessionState) -> String {
    var prompt = PromptState(
        prompt: getPrompt(state: state),
        content: "",
        cursorPosition: 0,
        continueReading: true,
        historyIndex: 0
    )
    let handlerRegistry = HandlerRegistry()

    var currentAction = InputAction.continueReading
    while currentAction == InputAction.continueReading {
        if let input = readRawInput() {
            let handler = handlerRegistry.get(sequence: input)
            currentAction = handler(input, &prompt, state)
            
        }
        fflush(nil)
    }
    return prompt.content
}
