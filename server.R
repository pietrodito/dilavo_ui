server <- function(input, output, session) {

 ## TODO deal with RESET button

 observeEvent(input$reset_mco_dgf, {
  f <- list.files("data", include.dirs = T, full.names = T, recursive = T)
  file.remove(f)
  session$reload()
 })
}
