
func updateHistory(cmd: Command) {
    if(_session.history.count == 0) {
        _session.history.append(cmd)
    } else if (_session.history.last! != cmd) {
        _session.history.append(cmd)
    }
    _session.historyIndex = _session.history.count
}
