possible_mapping_number <- 20

server <- function(input, output, session) {

 setup_dirs()

 score_data        <- NULL
 column_names      <- NULL
 mapping_data      <- NULL
 mapping_edit_data <- NULL
 load_score_data <- function(champ, statut) {

  score_path <- score_path(champ, statut)
  mapping_path <- mapping_path(champ, statut)

  suffixe <- str_under(champ, statut)
  if(file.exists(score_path)) {
   score_data[[suffixe]] <<- read_csv(score_path)
   column_names <- tibble(`Nom de colonne` = names(score_data[[suffixe]]))
  }

  mapping_file <- str_c("data/", suffixe, "/scores/code_mapping.rds")
  if(file.exists(mapping_file)) mapping_data <- read_rds(mapping_file)

  if(! is.null(column_names)) {
   if(! is.null(mapping_data)) {
   ## Il faut s'assurer que mapping_data a bien une ligne par
   ## code de code_data ??
   ## En fait la jointure fait déjà ce travail !? Non ?!
   ## TODO map_data = left_join(column_names, mapping_data)
    map_data <- left_join(column_names, mapping_data)
   } else {
    ((
     1:(possible_mapping_number)
     %>% str_c("map_", ., " = NA")
     %>% str_c(collapse = ", ")
     %>% str_c("add_column(column_names, ",
               ., ")")
    ) -> create_empty_map_data)
    mapping_edit_data[[suffixe]] <<- eval(parse(text = create_empty_map_data))
   }
  }
 }

 ## TODO load OVALIDE tabs as in memory-SQL database

 score_data_upload_fns   <- list(NULL)
 event_upload_score_data <- function(champ, statut) {

  remove_1st_and_last_column <- function(df) select(df, -c(1, ncol(df)))
  suffixe <- str_under(champ, statut)
  id <- str_under("MAJscores", suffixe)

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

 tab_data_upload_fns       <- list(NULL)
 event_upload_ovalide_data <- function(champ, statut) {

  suffixe <- str_under(champ, statut)
  id <- str_under("MAJtabs", suffixe)

  tab_data_upload_fns[[suffixe]] <<- reactive({
    req(input[[id]])
    filestr <- input[[id]]
    file.copy(filestr$datapath,
              str_c("data/", suffixe, "/ovalide/ovalide.zip"),
              overwrite = TRUE)
    session$reload()
   })

  observeEvent((tab_data_upload_fns[[suffixe]])(), {})
 }

 no_data_renderDT <- function() {
  renderDT(tibble(`Pour commencer...` =
                   "Veuillez téléverser un fichier avec les scores"),
           rownames = FALSE,
           options = list(dom = 't'))
 }

 display_score <- function(champ, statut) {

  suffixe <- str_under(champ, statut)
  output_var <- str_under("dash", champ, statut)

  define_js_callbacks("www/black_header_callback.js")

  data <- score_data[[suffixe]]
  output[[output_var]] <- if(is.null(data)) no_data_renderDT() else {
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
  }
 }

 display_mapping <- function(champ, statut) {

  suffixe <- str_under(champ, statut)
  output_var <- str_under("MAPscore", suffixe)

  data <- mapping_edit_data[[suffixe]]
  print(str_c("Display mapping: ", data))
  output[[output_var]] <- if(is.null(data)) {
   no_data_renderDT()
   } else {
   renderDT(data,
            rownames = FALSE,
            selection = list(mode = "single",
                             target = "row"),
            options = list(columnDefs = list(
            list(className = 'dt-center',
                  targets = 0:(ncol(data) - 1))),
             dom = 't',
             pageLength = -1,
             initComplete = JS(black_header_callback)))
   }
  }

 reset_event <- function(champ, statut) {

  input_var <- str_under("reset", champ, statut)
  data_path <- str_c("data/", champ, "_", statut)

  observeEvent(input[[input_var]], {
   f <- list.files(data_path, include.dirs = T, full.names = T, recursive = T)
   file.remove(f)
   session$reload()
  })
 }

 server_logic <- list(reset_event,
                      load_score_data,
                      event_upload_score_data,
                      event_upload_ovalide_data,
                      display_score,
                      display_mapping)

 apply_server_logic <- function(champ, statut) {
  walk(server_logic, ~ do.call(., list(champ, statut)))
 }

 pwalk(items_loop, apply_server_logic)
}
