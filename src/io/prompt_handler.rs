use std::io::Write;
use crate::core::session_state::SessionState;
use crate::core::get_prompt::get_prompt;
use crate::models::prompt_state::PromptState;
use crate::io::handler_registry::{HandlerRegistry, InputAction};
use crate::io::read_raw_input::read_raw_input;

pub fn handle_input(state: &mut SessionState) -> String {
    let mut prompt = PromptState {
        prompt: get_prompt(state),
        content: String::new(),
        cursor_position: 0,
        continue_reading: true,
        history_index: 0,
    };
    let handler_registry = HandlerRegistry::new();

    let mut current_action = InputAction::ContinueReading;
    while current_action == InputAction::ContinueReading {
        if let Some(input) = read_raw_input() {
            let handler = handler_registry.get(&input);
            current_action = handler(&input, &mut prompt, state);
        }
        std::io::stdout().flush().ok();
    }
    prompt.content
}
