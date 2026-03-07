use std::collections::HashMap;
use crate::builtins::builtin_command::BuiltInCommand;
use crate::builtins::cd_command::CdCommand;
use crate::builtins::exit_command::ExitCommand;
use crate::builtins::alias_command::AliasCommand;

pub struct BuiltInRegistry {
    commands: HashMap<String, Box<dyn BuiltInCommand>>,
}

impl BuiltInRegistry {
    pub fn new() -> Self {
        let mut registry = BuiltInRegistry {
            commands: HashMap::new(),
        };
        registry.register(Box::new(CdCommand));
        registry.register(Box::new(ExitCommand));
        registry.register(Box::new(AliasCommand));
        registry
    }

    fn register(&mut self, command: Box<dyn BuiltInCommand>) {
        self.commands.insert(command.name().to_string(), command);
    }

    pub fn get(&self, name: &str) -> Option<&dyn BuiltInCommand> {
        self.commands.get(name).map(|c| c.as_ref())
    }
}
