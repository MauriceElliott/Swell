
func parse(input: String) -> ASTNode {
	if input == "" {  return ASTNode.empty }
    
    let splitInput = input.split(separator: " ").map { String($0) }
    var command = ""
    var arguments = [""]
    if splitInput[0].contains("/") {
        command = String(splitInput[0])
        arguments = [ String(splitInput[0][splitInput[0].lastIndex(of: "/")!]) ]
        if splitInput.count > 1 {
            arguments.append(contentsOf: splitInput.filter { $0.contains("/") == false })
        }
    } else {
        command = splitInput[0]
        arguments = splitInput
    }
    return ASTNode.command((command, arguments))
}
