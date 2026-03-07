use std::collections::HashMap;
use crate::models::command::Command;

pub struct SessionState {
    pub available_commands: Vec<String>,
    pub environment: HashMap<String, String>,
    pub aliases: HashMap<String, Command>,
    pub home_dir: String,
    pub cur_dir: String,
    pub history: Vec<Command>,
    pub cont: bool,
}

impl SessionState {
    pub fn new(
        environment: HashMap<String, String>,
        home_directory: String,
        current_directory: String,
    ) -> Self {
        SessionState {
            available_commands: Vec::new(),
            environment,
            aliases: HashMap::new(),
            home_dir: home_directory,
            cur_dir: current_directory,
            history: Vec::new(),
            cont: true,
        }
    }
}
