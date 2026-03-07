use crate::core::session_state::SessionState;

pub trait BuiltInCommand {
    fn name(&self) -> &str;
    fn run(&self, args: &[String], state: &mut SessionState);
}
