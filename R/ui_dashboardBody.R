make_body <- function() {


 produce_subItems_list <- function() {

  produce_dash_subItems <- function() {

   produce_item <- function(champ, statut) {
    tabName <- str_under("dash", champ, statut)
    tabItem(tabName,
            div(style = 'overflow-x: scroll',
                DTOutput(tabName)))
   }
   pmap(items_loop, produce_item)
  }

  produce_reset_subItems <- function() {

   produce_item <- function(champ, statut) {
    tabName <- str_under("reset", champ, statut)
    tabItem(tabName,
            actionButton(tabName, str_c("Reset ", champ, " " , statut)))
   }
   pmap(items_loop, produce_item)
  }

  produce_MAPscore_subItems <- function() {

   produce_item <- function(champ, statut) {
    tabName <- str_under("MAPscore", champ, statut)
    tabItem(tabName,
            actionButton(tabName, NA))
   }
   pmap(items_loop, produce_item)
  }

  produce_upload_subItems <- function(tabName, label) {

   produce_item <- function(champ, statut) {
    tabName <- str_under(tabName, champ, statut)
    tabItem(tabName,
            fileInput(tabName,
                      label,
                      buttonLabel = "Parcourir...",
                      placeholder = "Aucun fichier séléctionné"))
   }
   pmap(items_loop, produce_item)
  }

  (subItems_list <- c(
   produce_reset_subItems(),
   produce_dash_subItems(),
   produce_MAPscore_subItems(),
   do.call(c, pmap(upload_tab_items_init_parameters, produce_upload_subItems))
  ))
 }

 include_custom_css <- function() {
  tags$head(tags$link(rel = "stylesheet",
                      type = "text/css",
                      href = "custom.css"))
 }

 dashboardBody(include_custom_css(),
               do.call(tabItems, produce_subItems_list()))
}
