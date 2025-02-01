import Foundation

func sanitiseInput(input: String?) -> Command? {
    if input == "" { return nil }
    
    let splitInput = input!.split(separator: " ").map { String($0) }
    var command = ""
    var arguments = [""]
    if splitInput[0].contains("/") {
        command = String(splitInput[0])
        arguments = [splitInput[0].substring(from: splitInput[0].lastIndex(of: "/")!)]
        if splitInput.count > 1 {
            arguments.append(contentsOf: splitInput.filter { $0.contains("/") == false })
        }
    } else {
        command = splitInput[0]
        arguments = splitInput
    }
    return (command, arguments)
}
