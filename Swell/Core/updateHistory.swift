
func updateHistory(cmd: Command) {
    if(Session.shared.history.count == 0) {
        Session.shared.history.append(cmd)
    } else if (Session.shared.history.last! != cmd) {
        Session.shared.history.append(cmd)
    }
    Session.shared.historyIndex = Session.shared.history.count
}
