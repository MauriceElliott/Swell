
func tabComplete(fuzz: String) -> String {
    if fuzz.count == 0 {
        return ""
    }
    if fuzz.split(separator: " ").count == 1 && fuzz.last != " " {
        let startsWith = Session.shared.availableCommands.filter{$0.starts(with: fuzz)}
        if(startsWith.count > 0) {
            return startsWith.first!.replacingOccurrences(of: fuzz, with: "")
        }
    } else if fuzz.split(separator: " ").count > 1 || fuzz.last == " " {
        //to be continued, this needs to autocomplete paths
    }
    
    return fuzz
}
