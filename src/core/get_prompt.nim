import strutils
import core/session_state

proc getPrompt*(state: SessionState): string =
  let directoryFromHome = state.curDir.replace(state.homeDir, "~/")
  return "\x1B[3;32m 󰶟  " & directoryFromHome & " => \x1B[0;39m"
