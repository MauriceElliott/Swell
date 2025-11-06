import Foundation

var sessionState = ConfigManager().initSessionState()
ConfigManager().loadConfiguration(state: &sessionState)
while sessionState.cont {
    print(getPrompt(state: sessionState), terminator: "")
    fflush(stdout)

    evaluate(node: parse(input: readInput(state: &sessionState)), state: &sessionState)
}
