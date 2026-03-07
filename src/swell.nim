import config/config_manager
import core/evaluator
import core/get_prompt
import io/prompt_handler
import io/flush
import parser/parser

var sessionState = initSessionState()
loadConfiguration(sessionState)

while sessionState.cont:
  write(stdout, getPrompt(sessionState))
  flushStdout()
  evaluate(parse(handleInput(sessionState)), sessionState)
  flushStdout()
