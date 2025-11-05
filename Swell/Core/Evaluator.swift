func evaluate(node: ASTNode, state: inout SessionState) {
	switch node {
    	case .command(let cmd):
			if let builtIn = BuiltInRegistry().get(name: cmd.command) {
				builtIn.run(args: cmd.arguments, state: &state)
			} else {
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
