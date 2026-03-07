use crate::models::prompt_state::PromptState;
use crate::core::session_state::SessionState;
use crate::io::handler_registry::InputAction;

pub fn handle_default(sequence: &str, prompt: &mut PromptState, _session: &SessionState) -> InputAction {
    prompt.content.push_str(sequence);
    print!("{}", sequence);
    InputAction::ContinueReading
}
