pub struct PromptState {
    #[allow(dead_code)]
    pub prompt: String,
    pub content: String,
    #[allow(dead_code)]
    pub cursor_position: usize,
    #[allow(dead_code)]
    pub continue_reading: bool,
    pub history_index: i32,
}
