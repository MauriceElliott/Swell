func evaluate(node: ASTNode, state: inout SessionState) {

	switch node {
    	case .command(let cmd):
			switch cmd.command {
				case "cd":
					changeDirectory(arguments: cmd.arguments, state: state)
					
				default:
					spawnProcess(command: cmd.command, arguments: cmd.arguments)


			}
		case .pipeline(let nodes):
        	for node in nodes {
				evaluate(node: node, state: &state)	
			}
    	default:
        	spawnProcess(command: "", arguments: [""])
    }
}
