initialize_header_context <- function(CustomHeader) {
 CustomHeader <- dashboardHeader(title = "DILAVO")
 CustomHeader$children[[3]]$children <- list(
  CustomHeader$children[[3]]$children,
  div(textOutput("header_context")))
 CustomHeader
}

make_CustomHeader <- function() initialize_header_context()
