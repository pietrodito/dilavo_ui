define_js_callbacks <- function(path) {

 parse_js_file <- function(path) {

  code_between_curve_brackets <- function(code) {
   if(! str_starts(code, "\\{")) stop("code must start with '{'")

   each_char <- function(string) str_split(code, "") %>% unlist
   chars <- each_char(code)

   opening_brackets <- 0
   char_position <- 1

   for(char in chars) {
    if(str_equal(char, "{")) opening_brackets <- opening_brackets + 1
    if(str_equal(char, "}")) opening_brackets <- opening_brackets - 1
    if(opening_brackets == 0) break
    char_position <- char_position + 1
   }
   str_sub(code, end = char_position)
  }

  get_fn_name_definition <- function(code) {
   str_extract(code, ".*=")
  }

  get_fn_name <- function(fn_name_definition) {
   (
     fn_name_definition
     %>% str_trim()
     %>% str_remove_all(" ")
     %>% str_remove("=")
    )
  }

  remove_already_read <- function(code, already_read) {
   (
    code
    %>% str_remove(coll(already_read))
    %>% str_trim()
   )
  }

  get_param_definition <- function(code) {
   str_extract(code, "function\\s*?\\(.*?\\)")
  }

  (file_content <- read_file(path))

  js_fns <- NULL

  while(str_length(file_content) > 0) {

   fn_name_definition <- get_fn_name_definition(file_content)
   fn_name            <- get_fn_name(fn_name_definition)
   file_content       <- remove_already_read(file_content, fn_name_definition)

   param_definition <- get_param_definition(file_content)
   file_content     <- remove_already_read(file_content, param_definition)

   body_definition <- code_between_curve_brackets(file_content)
   file_content    <- remove_already_read(file_content, body_definition)

   js_fns[[fn_name]] <- str_c(param_definition, body_definition)
  }

  js_fns
 }

 ## MAIN --------------------------------
 fns <- parse_js_file(path)

 fns_tbl <- tibble(fn_name = names(fns),
                   fn_string = fns %>% unlist)

 define_callback <- function(fn_name, fn_string) {
  assign(fn_name, fn_string, inherits = TRUE)
 }

 pwalk(fns_tbl, define_callback)
}

