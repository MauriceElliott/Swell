use crate::models::ast_node::ASTNode;
use crate::models::command::Command;

pub fn parse(input: &str) -> ASTNode {
    if input.is_empty() {
        return ASTNode::Empty;
    }

    let split_input: Vec<String> = input.split_whitespace().map(String::from).collect();
    let command;
    let arguments;

    if split_input[0].contains('/') {
        command = split_input[0].clone();
        let last_slash_idx = split_input[0].rfind('/').unwrap();
        let after_slash = &split_input[0][last_slash_idx..];
        let mut args = vec![after_slash.to_string()];
        if split_input.len() > 1 {
            args.extend(
                split_input
                    .iter()
                    .filter(|s| !s.contains('/'))
                    .cloned(),
            );
        }
        arguments = args;
    } else {
        command = split_input[0].clone();
        arguments = split_input;
    }

    ASTNode::Command(Command { command, arguments })
}
