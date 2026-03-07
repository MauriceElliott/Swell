import models/prompt_state
import core/session_state
import core/get_prompt
import io/handler_types
import io/handler_registry
import io/read_raw_input
import io/flush

proc handleInput*(state: SessionState): string =
  var prompt = PromptState(
    prompt: getPrompt(state),
    content: "",
    cursorPosition: 0,
    continueReading: true,
    historyIndex: 0,
  )
  let registry = newHandlerRegistry()

  var currentAction = ContinueReading
  while currentAction == ContinueReading:
    let input = readRawInput()
    if input.len > 0:
      let handler = registry.get(input)
      currentAction = handler(input, prompt, state)
    flushStdout()
  return prompt.content
