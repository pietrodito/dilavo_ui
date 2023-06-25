server <- function(input, output, session) {

 reset_event <- function(CHAMP, STATUT) {
  champ  <- str_to_lower(CHAMP)
  statut <- str_to_lower(STATUT)

  input_var <- str_c("reset", champ, statut, sep = "_")
  data_path <- str_c("data/", CHAMP, "_", STATUT)

  observeEvent(input[[input_var]], {
   f <- list.files(data_path, include.dirs = T, full.names = T, recursive = T)
   file.remove(f)
   session$reload()
  })
 }

 pwalk(items_loop, reset_event)
}
