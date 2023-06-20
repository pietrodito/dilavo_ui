options(shiny.maxRequestSize=30*1024^2)

js_black_header_callback <- paste(
   "function(settings, json) {",
    "$(this.api().table().header()).css(
                         {'background-color': '#ccc', 'color': '#000'});",
    "}")

load_score_data <-  function() {

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

 file_path <- "data/scores.csv"
 if( ! file.exists(file_path)) {
  return(NULL)
 } else {
  (
   "data/scores.csv"
   %>% read_csv()
   %>% select(-c(1, 23))
  ) -> score_data

  names(score_data) <- enhanced_colnames(score_data)
  return(score_data)
 }
}

server <- function(input, output, session) {

 proper_text_from_subitem <- function(selected_subitem) {
  tokens <- str_split(selected_subitem, "_") %>% unlist
  section <- subItems_pattern[subItems_pattern$tabName == tokens[1], "text"]
  champ <- str_to_upper(tokens[2])
  statut <- str_to_upper(tokens[3])
  str_c(champ, statut, section, sep = " ")
 }


 output$header_context <- renderText({
        proper_text_from_subitem(input$selected_subitem)})

 score_data <- load_score_data()

 file_ovalide <- reactive({
  req(input$fi_ovalide)
  filestr <- input$fi_ovalide
  file.copy(filestr$datapath, "data/ovalide.zip")
  session$reload()
 }); observeEvent(file_ovalide(), {})

 file_scores <- reactive({
  req(input$fi_scores)
  filestr <- input$fi_scores
  file <- read_csv2(filestr$datapath)
  write_csv(file, "data/scores.csv")
  session$reload()
 }); observeEvent(file_scores(), {})

 observeEvent(input$reset_action, {
  f <- list.files("data", include.dirs = T, full.names = T, recursive = T)
  file.remove(f)
  session$reload()
 })

 output$scores_mco_dgf <- if(! is.null(score_data)) {
  renderDT(score_data,
           rownames = FALSE,
           selection = list(mode = "single", target = "cell"),
           options = list(columnDefs = list(
            list(className = 'dt-center',
                 targets = 0:(ncol(score_data) - 1))),
            dom = 't',
            pageLength = nrow(score_data),
            initComplete = JS(js_black_header_callback )))
 } else {
  renderDT(tibble(`Pour commencer...` =
                   "Veuillez téléverser un fichier avec les scores"),
           rownames = FALSE,
           options = list(dom = 't'))
 }
}
