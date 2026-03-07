use crate::models::prompt_state::PromptState;
use crate::core::session_state::SessionState;
use crate::io::handler_registry::InputAction;
use crate::io::read_raw_input::read_raw_input;

enum Direction {
    Up,
    Down,
}

pub fn handle_arrow_key(_sequence: &str, prompt: &mut PromptState, session: &SessionState) -> InputAction {
    let sb = read_raw_input();
    if sb.as_deref() == Some("[") {
        let letter = read_raw_input();
        let direction = if letter.as_deref() == Some("B") {
            Direction::Down
        } else {
            Direction::Up
        };

        // Clear current content from display
        for _ in prompt.content.chars() {
            print!("\x1B[D\x1B[K");
        }

        let previous_history = read_history(&direction, prompt, session);
        prompt.content = previous_history;
        print!("{}", prompt.content);
    }
    InputAction::ContinueReading
}

fn read_history(direction: &Direction, prompt: &mut PromptState, session: &SessionState) -> String {
    if session.history.is_empty() {
        return String::new();
    }

    if prompt.history_index < 0 {
        prompt.history_index = 0;
    } else if prompt.history_index >= session.history.len() as i32 {
        prompt.history_index = session.history.len() as i32 - 1;
    }

    let entry = &session.history[prompt.history_index as usize];
    let result = entry.arguments.join(" ");

    prompt.history_index = match direction {
        Direction::Up => prompt.history_index - 1,
        Direction::Down => prompt.history_index + 1,
    };

    result
}
