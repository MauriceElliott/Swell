protocol BuiltInCommand {
    var name: String { get }
    func run(args: [String], state: inout SessionState)
}
