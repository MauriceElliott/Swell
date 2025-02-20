enum direction {
    case up
    case down
}

func readHistory(direction: direction) -> String {
    _session.historyIndex = direction == .up ? _session.historyIndex - 1: _session.historyIndex + 1;
    if (_session.historyIndex < 0) {
        _session.historyIndex = 0
    } else if (_session.historyIndex >= _session.history.count) {
        _session.historyIndex = _session.history.count - 1
    }
    let entry = _session.history[_session.historyIndex]
    var result = ""
    for arg in entry.arguments {
        result += arg + " "
    }
    return result
}
