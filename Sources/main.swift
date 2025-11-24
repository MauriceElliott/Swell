import Foundation

var sessionState = ConfigManager().initSessionState()
ConfigManager().loadConfiguration(state: &sessionState)
while sessionState.cont {
    print(getPrompt(state: sessionState), terminator: "")
    try? FileHandle.standardOutput.synchronize()
    evaluate(node: parse(input: handleInput(state: &sessionState)), state: &sessionState)
}
