import Foundation

var sessionState = ConfigManager().initSessionState()

while sessionState.cont {
    print(getPrompt(state: sessionState), terminator: "")
    fflush(stdout)

    evaluate(node: parse(input: readInput(state: &sessionState)), state: &sessionState)
}
