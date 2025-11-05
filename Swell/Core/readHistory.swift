enum direction {
    case up
    case down
}

func readHistory(direction: direction) -> String {
    Session.shared.historyIndex = direction == .up ? Session.shared.historyIndex - 1: Session.shared.historyIndex + 1;
    if (Session.shared.historyIndex < 0) {
        Session.shared.historyIndex = 0
    } else if (Session.shared.historyIndex >= Session.shared.history.count) {
        Session.shared.historyIndex = Session.shared.history.count - 1
    }
    let entry = Session.shared.history[Session.shared.historyIndex]
    var result = ""
    for arg in entry.arguments {
        result += arg + " "
    }
    return result
}
