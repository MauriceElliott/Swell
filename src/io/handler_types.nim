import models/prompt_state
import core/session_state

type
  InputAction* = enum
    ContinueReading,
    ReadHistory,
    SubmitInput

  InputHandler* = proc(sequence: string, prompt: var PromptState,
      session: SessionState): InputAction {.nimcall.}
