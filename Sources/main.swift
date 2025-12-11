import Foundation

var sessionState = ConfigManager().initSessionState()
ConfigManager().loadConfiguration(state: &sessionState)
while sessionState.cont {
    print(getPrompt(state: sessionState), terminator: "")
    flush_stdout()
    evaluate(node: parse(input: handleInput(state: &sessionState)), state: &sessionState)
    flush_stdout()
}
