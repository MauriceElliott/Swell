use super::command::Command;

pub enum ASTNode {
    Empty,
    Command(Command),
    #[allow(dead_code)]
    Pipeline(Vec<ASTNode>),
}
