#!/usr/bin/env nu

let theme_text_colors = {
  separator: "#4f4f4f"
  leading_trailing_space_bg: { attr: n }
  header: green_bold
  empty: blue
  bool: light_cyan
  int: white
  filesize: cyan
  duration: white
  date: purple
  range: white
  float: white
  string: white
  nothing: dark_gray
  binary: white
  cellpath: cyan
  row_index: blue
  hints: dark_gray
  search_result: blue

  shape_bool: white
  shape_directory: blue
  shape_external: white
  shape_externalarg: white
  shape_externalcall: white
  #shape_filepath: white
  shape_flag: white
  shape_float: white
  shape_globpattern: green
  shape_int: white
  shape_internalarg: white
  shape_internalcall: yellow
  shape_keyword: white
  shape_operator: white
  shape_pipe: white
  shape_string: white
  shape_variable: white
}

let theme_menu_colors = {
  selected_text:       { bg: "#4f4f4f" }
  match_text:          { fg: "green" }
  selected_match_text: { fg: "green" bg: "#4f4f4f" }
  description_text:    { fg: "gray" }
}
