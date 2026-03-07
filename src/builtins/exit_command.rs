use crate::builtins::builtin_command::BuiltInCommand;
use crate::core::session_state::SessionState;

pub struct ExitCommand;

impl BuiltInCommand for ExitCommand {
    fn name(&self) -> &str {
        "exit"
    }

    fn run(&self, _args: &[String], state: &mut SessionState) {
        state.cont = false;
    }
}
