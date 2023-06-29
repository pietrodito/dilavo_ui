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

 score_data <- list(NULL)

 load_score_data <- function(champ, statut) {
  path <- score_path(champ, statut)
  suffixe <- str_under(champ, statut)
  if(file.exists(score_path(champ, statut))) {
   score_data[[suffixe]] <<- read_csv(path)
  }
 }

 display_score <- function(champ, statut) {

  suffixe <- str_under(champ, statut)
  output_var <- str_c("dash", champ, statut, sep = "_")

  data <- score_data[[suffixe]]

 define_js_callbacks("www/black_header_callback.js")

  output[[output_var]] <- if(! is.null(data)) {
   renderDT(data,
            rownames = FALSE,
            selection = list(mode = "single",
                             target = "cell"),
            options = list(columnDefs = list(
            list(className = 'dt-center',
                  targets = 0:(ncol(data) - 1))),
             dom = 't',
             pageLength = -1,
             initComplete = JS(black_header_callback)))
  } else {
   renderDT(tibble(`Pour commencer...` =
                    "Veuillez téléverser un fichier avec les scores"),
            rownames = FALSE,
            options = list(dom = 't'))
   }
  }

 score_data_upload_fns  <- list(NULL)

 event_upload_score_data <- function(champ, statut) {

  remove_1st_and_last_column <- function(df) select(df, -c(1, ncol(df)))
  suffixe <- str_under(champ, statut)
  id <- str_under("MAJscores", suffixe)

  ## TODO use get_column_codes and store them

  score_data_upload_fns[[suffixe]] <<- reactive({
    req(input[[id]])
    filestr <- input[[id]]
    file <- read_csv2(filestr$datapath)
    file %<>% remove_1st_and_last_column()
    col_names <- names(file)
    names(file) <- if(champ == "psy") nettoie_nom_colonnes_psy(col_names)
                   else               nettoie_nom_colonnes(col_names)
    write_rds(get_column_codes(col_names),
              score_column_codes_path(champ, statut))
    write_csv(file, score_path(champ, statut))
    session$reload()
   })

  observeEvent((score_data_upload_fns[[suffixe]])(), {})
 }

 server_logic <- list(reset_event,
                      load_score_data,
                      event_upload_score_data,
                      display_score)

 apply_server_logic <- function(champ, statut) {
  walk(server_logic, ~ do.call(., list(champ, statut)))
 }

 pwalk(items_loop, apply_server_logic)
}
