import models/ast_node
import models/command
import core/session_state
import core/get_alias
import builtins/builtin_command
import builtins/builtin_registry
import io/process_spawner

proc evaluate*(node: ASTNode, state: SessionState) =
  case node.kind
  of CommandNode:
    let cmd = node.cmd
    let registry = newBuiltInRegistry()
    let builtIn = registry.get(cmd.command)
    if builtIn != nil:
      builtIn.run(cmd.arguments, state)
    else:
      let aliasedCmd = getAlias(cmd, state)
      if aliasedCmd.command != "":
        spawnProcess(aliasedCmd.command, aliasedCmd.arguments, state)
      spawnProcess(cmd.command, cmd.arguments, state)
    state.history.add(cmd)
  of Pipeline:
    for child in node.nodes:
      evaluate(child, state)
  of Empty:
    spawnProcess("", @[""], state)
