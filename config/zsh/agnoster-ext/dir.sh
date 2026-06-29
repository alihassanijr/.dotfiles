# Custom directory prompt colors

prompt_dir() {
  local dir_disp
  dir_disp=$(truncate_start "${(%):-%~}" "${OMZ_MAX_DIR_LENGTH:-30}")
  prompt_segment "#fa7970" black "$dir_disp"
}
