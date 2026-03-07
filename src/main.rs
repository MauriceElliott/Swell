mod models;
mod parser;
mod core;
mod io;
mod builtins;
mod config;

use std::io::Write;
use crate::config::config_manager::ConfigManager;
use crate::core::get_prompt::get_prompt;
use crate::core::evaluator::evaluate;
use crate::parser::parser::parse;
use crate::io::prompt_handler::handle_input;

fn main() {
    let mut session_state = ConfigManager::init_session_state();
    ConfigManager::load_configuration(&mut session_state);

    while session_state.cont {
        print!("{}", get_prompt(&session_state));
        std::io::stdout().flush().ok();

        let input = handle_input(&mut session_state);
        let node = parse(&input);
        evaluate(node, &mut session_state);

        std::io::stdout().flush().ok();
    }
}
