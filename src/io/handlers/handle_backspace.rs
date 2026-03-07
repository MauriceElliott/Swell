use crate::models::prompt_state::PromptState;
use crate::core::session_state::SessionState;
use crate::io::handler_registry::InputAction;

pub fn handle_backspace(_sequence: &str, prompt: &mut PromptState, _session: &SessionState) -> InputAction {
    if !prompt.content.is_empty() {
        prompt.content.pop();
        print!("\x1B[1D\x1B[K");
    }
    InputAction::ContinueReading
}
