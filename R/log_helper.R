if(log_2_file) sink(log_file)


log_new_session_box <- function() {
 box_line()
 box_text("NOUVELLE SESSION")
 box_text(lubridate::now())
 box_line()
}


ncat <- function(...) cat(str_c(...), "\n")
line_width <- 80
box_line <- function() ncat(str_dup("-", line_width))
box_text <- function(text) {
 ncat("|", str_pad(text, line_width - 2, side = "both"), "|")
}
