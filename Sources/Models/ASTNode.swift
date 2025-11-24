enum ASTNode {
	case empty
	case command(Command)
	case pipeline([ASTNode])
}
