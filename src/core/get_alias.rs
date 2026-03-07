use crate::models::command::Command;
use crate::core::session_state::SessionState;

pub fn get_alias(cmd: &Command, state: &SessionState) -> Option<Command> {
    if let Some(alias) = state.aliases.get(&cmd.arguments[0]) {
        let mut command = alias.clone();
        if cmd.arguments.len() > 1 {
            let remaining_args = &cmd.arguments[1..];
            command.arguments.extend_from_slice(remaining_args);
        }
        Some(command)
    } else {
        None
    }
}
