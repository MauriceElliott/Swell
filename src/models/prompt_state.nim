type
  PromptState* = object
    prompt*: string
    content*: string
    cursorPosition*: int
    continueReading*: bool
    historyIndex*: int
