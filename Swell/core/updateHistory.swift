
func updateHistory(cmd: Command) {
    _session.historyIndex = 0
    if(_session.history.count == 0) {
        _session.history.append(cmd)
    } else if (_session.history.last! != cmd) {
        _session.history.append(cmd)
    }
}
