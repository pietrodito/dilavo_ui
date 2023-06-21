options(shiny.maxRequestSize=30*1024^2)

js_black_header_callback <- paste(
   "function(settings, json) {",
    "$(this.api().table().header()).css(
                         {'background-color': '#ccc', 'color': '#000'});",
    "}")

load_score_data <-  function(champ, statut) {

 enhanced_colnames <- function(score_data) {
  (
   score_data
   %>% colnames()
   %>% str_remove_all("^Score.*'")
   %>% str_remove_all("[\\(|\\)|:|\\\"]")
   %>% str_trim()
   %>% str_replace("score ","score\n")
  )
 }

 file_path <- str_c("data/", champ, "_", statut,"/scores.csv")
 if( ! file.exists(file_path)) {
  return(NULL)
 } else {
  (
   file_path
   %>% read_csv()
   %>% select(-c(1, 23))
  ) -> score_data

  names(score_data) <- enhanced_colnames(score_data)
  return(score_data)
 }
}

server <- function(input, output, session) {

 ## TODO eval(parse) not gonna work inside function
 ## Use same technique as ui_body
 ## 1) define all needed variables
 ## 2) then assign with inherits = TRUE

 champ <- "mco"
 statut <- "dgf"
 suffixe <- str_c("_", champ, "_", statut)

 make_file_scores_reactive <- function(champ, statut) {
  reactive({
   eval(parse(text = str_c("req(input$fi_scores", champ, "_", statut, ")")))
   filestr <- input$fi_scores
   file <- read_csv2(filestr$datapath)
   write_csv(file, str_c("data/", champ, "_", statut, "/scores.csv"))
   session$reload()
  })
 }

 proper_text_from_subitem <- function(selected_subitem) {
  tokens <- str_split(selected_subitem, "_") %>% unlist
  section <- subItems_pattern[subItems_pattern$tabName == tokens[1], "text"]
  champ <- str_to_upper(tokens[2])
  statut <- str_to_upper(tokens[3])
  str_c(champ, statut, section, sep = " ")
 }

 output$header_context <- renderText({
        proper_text_from_subitem(input$selected_subitem)})

 score_data_mco_dgf <- load_score_data("mco", "dgf")

 file_ovalide <- reactive({
  req(input$fi_ovalide)
  filestr <- input$fi_ovalide
  file.copy(filestr$datapath, "data/ovalide.zip")
  session$reload()
 }); observeEvent(file_ovalide(), {})

 eval(parse(text = str_c(
  "file_scores", suffixe, " <- make_file_scores_reactive(\"", champ,"\",\"", statut,"\");",
  "observeEvent(file_scores", suffixe, "(), {})"
 )))

 observeEvent(input$reset_action, {
  f <- list.files("data", include.dirs = T, full.names = T, recursive = T)
  file.remove(f)
  session$reload()
 })

 output$scores_mco_dgf <- if(! is.null(score_data_mco_dgf)) {
  renderDT(score_data_mco_dgf,
           rownames = FALSE,
           selection = list(mode = "single", target = "cell"),
           options = list(columnDefs = list(
            list(className = 'dt-center',
                 targets = 0:(ncol(score_data_mco_dgf) - 1))),
            dom = 't',
            pageLength = nrow(score_data_mco_dgf),
            initComplete = JS(js_black_header_callback)))
 } else {
  renderDT(tibble(`Pour commencer...` =
                   "Veuillez téléverser un fichier avec les scores"),
           rownames = FALSE,
           options = list(dom = 't'))
 }
}
