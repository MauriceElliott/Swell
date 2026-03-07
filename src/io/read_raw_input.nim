import posix
import posix/termios as posix_termios

proc cfMakeRaw(termios: ptr Termios) {.importc: "cfmakeraw",
    header: "<termios.h>".}

proc readRawInput*(): string =
  var oldTerm, newTerm: Termios
  discard tcGetAttr(STDIN_FILENO.cint, addr oldTerm)
  newTerm = oldTerm
  cfMakeRaw(addr newTerm)
  discard tcSetAttr(STDIN_FILENO.cint, TCSANOW, addr newTerm)

  var buf: array[2, char]
  let bytesRead = read(STDIN_FILENO.cint, addr buf[0], 1)

  discard tcSetAttr(STDIN_FILENO.cint, TCSANOW, addr oldTerm)

  if bytesRead > 0:
    result = $buf[0]
  else:
    result = ""
