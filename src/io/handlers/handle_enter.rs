use crate::models::prompt_state::PromptState;
use crate::core::session_state::SessionState;
use crate::io::handler_registry::InputAction;

pub fn handle_enter(_sequence: &str, _prompt: &mut PromptState, _session: &SessionState) -> InputAction {
    print!("\n");
    InputAction::SubmitInput
}
