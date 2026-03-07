use crate::models::ast_node::ASTNode;
use crate::core::session_state::SessionState;
use crate::core::get_alias::get_alias;
use crate::builtins::builtin_registry::BuiltInRegistry;
use crate::io::process_spawner::spawn_process;

pub fn evaluate(node: ASTNode, state: &mut SessionState) {
    match node {
        ASTNode::Command(cmd) => {
            let registry = BuiltInRegistry::new();
            if let Some(builtin) = registry.get(&cmd.command) {
                builtin.run(&cmd.arguments, state);
            } else {
                if let Some(aliased_cmd) = get_alias(&cmd, state) {
                    spawn_process(&aliased_cmd.command, &aliased_cmd.arguments, state);
                }
                spawn_process(&cmd.command, &cmd.arguments, state);
            }
            state.history.push(cmd);
        }
        ASTNode::Pipeline(nodes) => {
            for node in nodes {
                evaluate(node, state);
            }
        }
        ASTNode::Empty => {
            spawn_process("", &[String::new()], state);
        }
    }
}
