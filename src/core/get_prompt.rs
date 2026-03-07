use crate::core::session_state::SessionState;

pub fn get_prompt(state: &SessionState) -> String {
    let directory_from_home = state.cur_dir.replace(&state.home_dir, "~/");
    format!("\x1B[3;32m 󰶟  {} => \x1B[0;39m", directory_from_home)
}
