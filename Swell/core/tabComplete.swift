
var _tabCompletions: [String] = ["fizzbuzz", "swell", "test"]

func tabComplete(fuzz: String) -> String {
    let startsWith = _tabCompletions.filter{$0.starts(with: fuzz)}
    if(startsWith.count > 0) {
        return startsWith.first!.replacingOccurrences(of: fuzz, with: "")
    }
    return fuzz
}
