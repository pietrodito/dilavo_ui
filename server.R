options(shiny.maxRequestSize=30*1024^2)

js_black_header_callback <- paste(
   "function(settings, json) {",
    "$(this.api().table().header()).css(
                         {'background-color': '#ccc', 'color': '#000'});",
    "}")

server <- function(input, output, session) {

 score_data <- NULL
 if(file.exists("data/scores.csv")) {
  (
   "data/scores.csv"
   %>% read_csv()
   %>% select(- Region)
  ) -> score_data
 }

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


 output$scores <- if(! is.null(score_data)) {
                  renderDT(score_data,
                           rownames = FALSE,
                           selection = list(mode = "single", target = "cell"),
                           options = list(
                           columnDefs = list(
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
