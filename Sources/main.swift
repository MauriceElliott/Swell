import Foundation

var sessionState = ConfigManager().initSessionState()
ConfigManager().loadConfiguration(state: &sessionState)
setbuf(stdout, nil)
while sessionState.cont {
    print(getPrompt(state: sessionState), terminator: "")
    evaluate(node: parse(input: handleInput(state: &sessionState)), state: &sessionState)
}
