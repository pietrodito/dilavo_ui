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

 create_score_data_var <- function(CHAMP, STATUT) {
  champ  <- str_to_lower(CHAMP)
  statut <- str_to_lower(STATUT)
  eval(parse(text = str_c("score_data_", champ, "_", statut, "<<- NULL")))
 }

 pwalk(items_loop, create_score_data_var)

 display_score <- function(CHAMP, STATUT) {
  champ  <- str_to_lower(CHAMP)
  statut <- str_to_lower(STATUT)

  output_var <- str_c("dash", champ, statut, sep = "_")
  data_var   <- str_c("score_data", champ, statut, sep = "_")

  output[[output_var]] <- if(! is.null(get(data_var))) {
   renderDT(get(data_var),
            rownames = FALSE,
            selection = list(mode = "single", target = "cell"),
            options = list(columnDefs = list(
             list(className = 'dt-center',
                  targets = 0:(ncol(score_data_mco_dgf) - 1))),
             dom = 't',
             pageLength = nrow(get(data_var)),
             initComplete = JS(js_black_header_callback)))
  } else {
   renderDT(tibble(`Pour commencer...` =
                    "Veuillez téléverser un fichier avec les scores"),
            rownames = FALSE,
            options = list(dom = 't'))
   }
  }

 pwalk(items_loop, display_score)
}
