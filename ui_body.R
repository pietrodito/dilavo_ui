dash_mco_dfg_item <- tabItem("dash_mco_dgf", DTOutput("scores_mco_dgf"))
upload_tab_items_setup <- tribble(
 ~ tabName,    ~ var,         ~ label,
 "up_scores_mco_dfg",   "fi_scores_mco_dfg",   "Téléversez les scores",
 "up_ovalide_mco_dfg",  "fi_ovalide_mco_dfg",  "Téléversez les tableaux OVALIDE",
 "up_contacts_mco_dfg", "fi_contacts_mco_dfg", "Téléversez les contacts"
)
file_input_helper <- function(var, label) {
 fileInput(var, label,
           buttonLabel = "Parcourir...",
           placeholder = "Aucun fichier séléctionné"
           )
}
init_upload_tab_item <- function(tabName, var, label) {
 tabItem(tabName, file_input_helper(var, label))
}
list_upload_tab_items <- pmap(upload_tab_items_setup, init_upload_tab_item)

reset_tab_item <- tabItem("reset_mco_dgf", actionButton("reset_action",
                                                        "Reset MCO DGF"))


make_body <- function() {
 dashboardBody(
  tags$head(tags$link(rel = "stylesheet",
                      type = "text/css",
                      href = "custom.css")),
  tabItems(dash_mco_dfg_item,
           reset_tab_item))
}
