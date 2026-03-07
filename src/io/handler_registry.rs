use std::collections::HashMap;

use crate::models::prompt_state::PromptState;
use crate::core::session_state::SessionState;
use crate::io::handlers::{
    handle_enter::handle_enter,
    handle_backspace::handle_backspace,
    handle_arrow_key::handle_arrow_key,
    handle_tab::handle_tab,
    handle_default::handle_default,
};

#[derive(PartialEq)]
pub enum InputAction {
    ContinueReading,
    #[allow(dead_code)]
    ReadHistory,
    SubmitInput,
}

pub type InputHandler = fn(&str, &mut PromptState, &SessionState) -> InputAction;

pub struct HandlerRegistry {
    handlers: HashMap<String, InputHandler>,
}

impl HandlerRegistry {
    pub fn new() -> Self {
        let mut registry = HandlerRegistry {
            handlers: HashMap::new(),
        };
        registry.register("\r", handle_enter);
        registry.register("\x7F", handle_backspace);
        registry.register("\x1B", handle_arrow_key);
        registry.register("\t", handle_tab);
        registry
    }

    pub fn register(&mut self, sequence: &str, handler: InputHandler) {
        self.handlers.insert(sequence.to_string(), handler);
    }

    pub fn get(&self, sequence: &str) -> InputHandler {
        if let Some(handler) = self.handlers.get(sequence) {
            *handler
        } else {
            handle_default
        }
    }
}
