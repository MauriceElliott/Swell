
func tabComplete(fuzz: String) -> String {
    let startsWith = _session.availableCommands.filter{$0.starts(with: fuzz)}
    if(startsWith.count > 0) {
        return startsWith.first!.replacingOccurrences(of: fuzz, with: "")
    }
    return fuzz
}
