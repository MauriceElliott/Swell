package shell_io

import "core:os"
import "core:strings"
import psx "core:sys/posix"

read_raw_input :: proc() -> (string, bool) {
	old_term: psx.termios
	psx.tcgetattr(psx.STDIN_FILENO, &old_term)

	// cfmakeraw equivalent
	raw := old_term
	raw.c_iflag -= {.IGNBRK, .BRKINT, .PARMRK, .ISTRIP, .INLCR, .IGNCR, .ICRNL, .IXON}
	raw.c_oflag -= {.OPOST}
	raw.c_lflag -= {.ECHO, .ECHONL, .ICANON, .ISIG, .IEXTEN}
	raw.c_cflag -= {.PARENB}
	raw.c_cflag -= psx.CSIZE
	raw.c_cflag += {.CS8}
	psx.tcsetattr(psx.STDIN_FILENO, .TCSANOW, &raw)
	defer psx.tcsetattr(psx.STDIN_FILENO, .TCSANOW, &old_term)

	buf: [1]u8
	bytes_read := psx.read(psx.STDIN_FILENO, raw_data(buf[:]), size_of(buf))
	if bytes_read > 0 {
		return strings.clone_from_bytes(buf[:bytes_read], context.temp_allocator), true
	}
	return "", false
}

flush_stdout :: proc() {
	os.flush(os.stdout)
}
