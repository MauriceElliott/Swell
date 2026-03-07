import strutils
import models/ast_node

proc parse*(input: string): ASTNode =
  if input.strip() == "":
    return ASTNode(kind: Empty)

  let splitInput = input.split(' ')
  var command: string
  var arguments: seq[string]

  if '/' in splitInput[0]:
    command = splitInput[0]
    let lastSlashIdx = splitInput[0].rfind('/')
    arguments = @[$splitInput[0][lastSlashIdx]]
    if splitInput.len > 1:
      for token in splitInput[1 .. ^1]:
        if '/' notin token:
          arguments.add(token)
  else:
    command = splitInput[0]
    arguments = splitInput

  return ASTNode(kind: CommandNode, cmd: (command: command, arguments: arguments))
