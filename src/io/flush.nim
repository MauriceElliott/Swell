proc flushStdout*() =
  proc fflush(f: File): cint {.importc: "fflush", header: "<stdio.h>".}
  discard fflush(stdout)
