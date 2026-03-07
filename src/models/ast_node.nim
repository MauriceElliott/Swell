import command

type
  ASTNodeKind* = enum
    Empty,
    CommandNode,
    Pipeline

  ASTNode* = object
    case kind*: ASTNodeKind
    of Empty: discard
    of CommandNode:
      cmd*: Command
    of Pipeline:
      nodes*: seq[ASTNode]
