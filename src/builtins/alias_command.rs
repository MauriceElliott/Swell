use crate::builtins::builtin_command::BuiltInCommand;
use crate::core::session_state::SessionState;
use crate::models::command::Command;

pub struct AliasCommand;

impl BuiltInCommand for AliasCommand {
    fn name(&self) -> &str {
        "alias"
    }

    fn run(&self, args: &[String], state: &mut SessionState) {
        if args.len() >= 3 {
            state.aliases.insert(
                args[1].clone(),
                Command {
                    command: args[2].clone(),
                    arguments: args[2..].to_vec(),
                },
            );
        }
    }
}
