use std::process;
use crate::core::session_state::SessionState;

pub fn spawn_process(command: &str, arguments: &[String], state: &SessionState) {
    if command.is_empty() {
        return;
    }

    let args = if arguments.len() > 1 {
        &arguments[1..]
    } else {
        &[]
    };

    let mut cmd = process::Command::new(command);
    cmd.args(args);

    // Set environment variables
    for (key, value) in &state.environment {
        cmd.env(key, value);
    }

    match cmd.status() {
        Ok(status) => {
            if !status.success() {
                if let Some(code) = status.code() {
                    if code != 0 {
                        // Process exited with non-zero status — silently continue like the Swift version
                    }
                }
            }
        }
        Err(e) => {
            eprintln!("Failed to spawn process: {}", e);
        }
    }
}
