server <- function(input, output, session) {

 reset_event <- function(champ, statut) {

  input_var <- str_c("reset", champ, statut, sep = "_")
  data_path <- str_c("data/", champ, "_", statut)

  observeEvent(input[[input_var]], {
   f <- list.files(data_path, include.dirs = T, full.names = T, recursive = T)
   file.remove(f)
   session$reload()
  })
 }


 create_score_data_var <- function(champ, statut) {
  eval(parse(text = str_c("score_data_", champ, "_", statut, "<<- NULL")))
 }


 display_score <- function(champ, statut) {

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

 server_logic <- list(reset_event,
                      create_score_data_var,
                      display_score)

 apply_server_logic <- function(champ, statut) {
  walk(server_logic, ~ do.call(., list(champ, statut)))
 }

 pwalk(items_loop, apply_server_logic)
}
