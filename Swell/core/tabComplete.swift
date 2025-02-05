
var _tabCompletions: [String] = ["fizzbuzz"]

func tabComplete(fuzz: String) -> String {
    assert(fuzz.last == "\t")
    var match = fuzz
    match.removeLast()
    let startsWith = _tabCompletions.filter{$0.starts(with: match)}
    return startsWith.first ?? fuzz
}
