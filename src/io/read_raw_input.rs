use std::io::Read;
use nix::sys::termios;
use std::os::fd::BorrowedFd;

pub fn read_raw_input() -> Option<String> {
    let stdin_fd = std::io::stdin();

    // Save old terminal settings
    let fd = unsafe { BorrowedFd::borrow_raw(0) };
    let old_term = termios::tcgetattr(fd).ok()?;

    // Set raw mode
    let mut new_term = old_term.clone();
    termios::cfmakeraw(&mut new_term);
    termios::tcsetattr(fd, termios::SetArg::TCSANOW, &new_term).ok()?;

    // Read a single byte
    let mut buf = [0u8; 1];
    let result = stdin_fd.lock().read(&mut buf);

    // Restore old terminal settings
    termios::tcsetattr(fd, termios::SetArg::TCSANOW, &old_term).ok()?;

    match result {
        Ok(n) if n > 0 => Some(String::from_utf8_lossy(&buf[..n]).to_string()),
        _ => None,
    }
}
