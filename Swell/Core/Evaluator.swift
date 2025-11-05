func evaluate(node: ASTNode, state: inout SessionState) {
	switch node {
    	case .command(let cmd):
			switch cmd.command {
				case "cd":
					state.curDir = changeDirectory(arguments: cmd.arguments, state: state)
				case "alias":
					state.aliases[cmd.arguments[1]] = Command(command: cmd.arguments[2], arguments: Array(cmd.arguments[2...]))
				case "exit":
					state.cont = false
				default:
					spawnProcess(command: cmd.command, arguments: cmd.arguments, state: state)
			}
			state.history.append(cmd)
			state.historyIndex += 1
		case .pipeline(let nodes):
        	for node in nodes {
				evaluate(node: node, state: &state)	
			}
    	default:
        	spawnProcess(command: "", arguments: [""], state: state)
    }
}
