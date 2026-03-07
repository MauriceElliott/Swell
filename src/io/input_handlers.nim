import strutils, sequtils
import models/prompt_state
import core/session_state
import io/handler_types
import io/read_raw_input

type
  Direction = enum
    Up, Down

# --- handleEnter ---
proc handleEnter*(sequence: string, prompt: var PromptState,
    session: SessionState): InputAction =
  write(stdout, "\n")
  return SubmitInput

# --- handleBackspace ---
proc handleBackspace*(sequence: string, prompt: var PromptState,
    session: SessionState): InputAction =
  if prompt.content.len > 0:
    prompt.content = prompt.content[0 ..< prompt.content.len - 1]
    write(stdout, "\x1B[1D\x1B[K")
  return ContinueReading

# --- handleDefault ---
proc handleDefault*(sequence: string, prompt: var PromptState,
    session: SessionState): InputAction =
  prompt.content &= sequence
  write(stdout, sequence)
  return ContinueReading

# --- tabComplete ---
proc tabComplete(fuzz: string, state: SessionState): string =
  if fuzz.len == 0:
    return ""
  let parts = fuzz.split(' ')
  if parts.len == 1 and fuzz[^1] != ' ':
    let matches = state.availableCommands.filterIt(it.startsWith(fuzz))
    if matches.len > 0:
      return matches[0].replace(fuzz, "")
  # path autocomplete to be continued
  return fuzz

# --- handleTab ---
proc handleTab*(sequence: string, prompt: var PromptState,
    session: SessionState): InputAction =
  let completed = tabComplete(prompt.content, session)
  if completed != prompt.content:
    prompt.content &= completed
    write(stdout, completed)
  return ContinueReading

# --- readHistory ---
proc readHistory(direction: Direction, prompt: var PromptState,
    session: SessionState): string =
  if prompt.historyIndex < 0:
    prompt.historyIndex = 0
  elif prompt.historyIndex >= session.history.len:
    prompt.historyIndex = session.history.len - 1
  let entry = session.history[prompt.historyIndex]
  var res = ""
  for arg in entry.arguments:
    res &= arg & " "
  if direction == Up:
    prompt.historyIndex -= 1
  else:
    prompt.historyIndex += 1
  return res

# --- handleArrowKey ---
proc handleArrowKey*(sequence: string, prompt: var PromptState,
    session: SessionState): InputAction =
  let sb = readRawInput()
  if sb == "[":
    let letter = readRawInput()
    let dir = if letter == "B": Down else: Up
    for _ in prompt.content:
      write(stdout, "\x1B[D\x1B[K")
    let previousHistory = readHistory(dir, prompt, session)
    prompt.content = previousHistory
    write(stdout, prompt.content)
  return ContinueReading
