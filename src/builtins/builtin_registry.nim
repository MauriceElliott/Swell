import tables
import builtins/builtin_command
import builtins/cd_command
import builtins/exit_command
import builtins/alias_command

type
  BuiltInRegistry* = object
    commands: Table[string, BuiltInCommand]

proc newBuiltInRegistry*(): BuiltInRegistry =
  result.commands = initTable[string, BuiltInCommand]()
  let cd = newCdCommand()
  let exit = newExitCommand()
  let alias = newAliasCommand()
  result.commands[cd.name] = cd
  result.commands[exit.name] = exit
  result.commands[alias.name] = alias

proc get*(registry: BuiltInRegistry, name: string): BuiltInCommand =
  if registry.commands.hasKey(name):
    return registry.commands[name]
  return nil
