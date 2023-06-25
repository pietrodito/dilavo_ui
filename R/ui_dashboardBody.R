make_body <- function() {

 produce_subItems_list <- function() {

  produce_dash_subItems <- function() {

   produce_item <- function(CHAMP, STATUT) {
    champ   <- str_to_lower(CHAMP)
    statut  <- str_to_lower(STATUT)
    tabName <- str_c("dash_", champ, "_", statut)
    tabItem(tabName, DTOutput(tabName))
   }
   pmap(items_loop, produce_item)
  }

  produce_reset_subItems <- function() {

   produce_item <- function(CHAMP, STATUT) {
    champ   <- str_to_lower(CHAMP)
    statut  <- str_to_lower(STATUT)
    tabName <- str_c("reset_", champ, "_", statut)
    tabItem(tabName,
            actionButton(tabName, str_c("Reset ", CHAMP, " " , STATUT)))
   }
   pmap(items_loop, produce_item)
  }

  produce_MAPscore_subItems <- function() {

   produce_item <- function(CHAMP, STATUT) {
    champ   <- str_to_lower(CHAMP)
    statut  <- str_to_lower(STATUT)
    tabName <- str_c("MAPscore_", champ, "_", statut)
    tabItem(tabName,
            actionButton(tabName, NA))
   }
   pmap(items_loop, produce_item)
  }

  produce_upload_subItems <- function(tabName, label) {

   produce_item <- function(CHAMP, STATUT) {
    champ   <- str_to_lower(CHAMP)
    statut  <- str_to_lower(STATUT)
    tabName <- str_c(tabName, "_", champ, "_", statut)
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
