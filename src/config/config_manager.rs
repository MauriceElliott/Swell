use std::collections::HashMap;
use std::env;
use std::fs;
use std::path::Path;

use crate::core::session_state::SessionState;
use crate::core::evaluator::evaluate;
use crate::parser::parser::parse;

pub struct ConfigManager;

impl ConfigManager {
    pub fn get_file_directory(home_dir: &str) -> String {
        let main_dir = format!("{}/.config/swell/", home_dir);
        let backup_dir = format!("{}/.swell/", home_dir);
        let file_name = "config.swell";
        let main_file = format!("{}{}", main_dir, file_name);
        let backup_file = format!("{}{}", backup_dir, file_name);

        if Path::new(&main_dir).is_dir() && Path::new(&main_file).is_file() {
            return main_file;
        } else if Path::new(&backup_dir).is_dir() && Path::new(&backup_file).is_file() {
            return backup_file;
        }

        // Create the main directory if it doesn't exist
        if !Path::new(&main_dir).is_dir() {
            if let Err(e) = fs::create_dir_all(&main_dir) {
                eprintln!("Failed to create directory for file: {}", e);
            }
        }

        // Write a default config
        if let Err(e) = fs::write(&main_file, "echo Hello World") {
            eprintln!("Failed to initialise configuration file: {}", e);
        }

        main_file
    }

    pub fn load_configuration(state: &mut SessionState) {
        let file_dir = Self::get_file_directory(&state.home_dir);
        println!("debug filedir: {}", file_dir);

        match fs::read_to_string(&file_dir) {
            Ok(contents) => {
                if !contents.is_empty() {
                    for line in contents.lines() {
                        let node = parse(line);
                        evaluate(node, state);
                    }
                }
            }
            Err(_) => {
                eprintln!("error reading configuration file, must be utf8 encoded!");
            }
        }
    }

    pub fn init_session_state() -> SessionState {
        let home_dir = env::var("HOME").unwrap_or_else(|_| String::from("/"));
        let current_dir = env::current_dir()
            .map(|p| p.to_string_lossy().to_string())
            .unwrap_or_else(|_| String::from("/"));

        let mut environment = HashMap::new();
        environment.insert("TERM".to_string(), "xterm-256color".to_string());
        environment.insert("COLORTERM".to_string(), "truecolor".to_string());

        let mut session = SessionState::new(environment, home_dir, current_dir);
        Self::update_available_commands(&mut session);
        session
    }

    pub fn update_available_commands(state: &mut SessionState) {
        let mut commands: Vec<String> = Vec::new();
        let path = env::var("PATH").unwrap_or_default();
        let path_directories: Vec<&str> = path.split(':').collect();

        for dir in path_directories {
            if let Ok(entries) = fs::read_dir(dir) {
                for entry in entries.flatten() {
                    if let Some(name) = entry.file_name().to_str() {
                        commands.push(name.to_string());
                    }
                }
            }
        }

        state.available_commands = commands;
    }
}
