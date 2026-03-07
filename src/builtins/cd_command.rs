use std::env;
use std::path::Path;
use crate::builtins::builtin_command::BuiltInCommand;
use crate::core::session_state::SessionState;

pub struct CdCommand;

impl BuiltInCommand for CdCommand {
    fn name(&self) -> &str {
        "cd"
    }

    fn run(&self, args: &[String], state: &mut SessionState) {
        if args.len() == 1 {
            // No argument: go home
            if env::set_current_dir(&state.home_dir).is_ok() {
                state.cur_dir = state.home_dir.clone();
            } else {
                eprintln!("Failed to go home.");
                state.cur_dir = env::current_dir()
                    .map(|p| p.to_string_lossy().to_string())
                    .unwrap_or_default();
            }
        } else {
            match args[1].as_str() {
                "~" => {
                    let _ = env::set_current_dir(&state.home_dir);
                    state.cur_dir = state.home_dir.clone();
                }
                ".." => {
                    if let Some(parent) = Path::new(&state.cur_dir).parent() {
                        let new_dir = parent.to_string_lossy().to_string();
                        if env::set_current_dir(&new_dir).is_ok() {
                            state.cur_dir = new_dir;
                        }
                    }
                }
                "/" => {
                    let _ = env::set_current_dir(&args[1]);
                    state.cur_dir = env::current_dir()
                        .map(|p| p.to_string_lossy().to_string())
                        .unwrap_or_default();
                }
                _ => {
                    let new_dir = format!("{}/{}", state.cur_dir, args[1]);
                    if env::set_current_dir(&new_dir).is_ok() {
                        state.cur_dir = new_dir;
                    }
                }
            }
        }
    }
}
