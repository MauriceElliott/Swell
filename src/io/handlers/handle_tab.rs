use crate::models::prompt_state::PromptState;
use crate::core::session_state::SessionState;
use crate::io::handler_registry::InputAction;

pub fn handle_tab(_sequence: &str, prompt: &mut PromptState, session: &SessionState) -> InputAction {
    let completed = tab_complete(&prompt.content, session);
    if completed != prompt.content {
        prompt.content.push_str(&completed);
        print!("{}", completed);
    }
    InputAction::ContinueReading
}

fn tab_complete(fuzz: &str, state: &SessionState) -> String {
    if fuzz.is_empty() {
        return String::new();
    }

    let parts: Vec<&str> = fuzz.split_whitespace().collect();
    if parts.len() == 1 && !fuzz.ends_with(' ') {
        let starts_with: Vec<&String> = state
            .available_commands
            .iter()
            .filter(|cmd| cmd.starts_with(fuzz))
            .collect();
        if !starts_with.is_empty() {
            return starts_with[0].replacen(fuzz, "", 1);
        }
    }
    // Path completion to be continued

    fuzz.to_string()
}
