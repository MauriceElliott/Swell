
func mainSwitch(cmd: Command){
    switch cmd.command {
    case "exit":
        runSwell = false;
    case "cd":
        changeDirectory(arguments: cmd.arguments)
    case "alias":
        addAlias(alias: cmd.arguments)
    default:
        spawnProcess(command: cmd.command, arguments: cmd.arguments)
    }
}
