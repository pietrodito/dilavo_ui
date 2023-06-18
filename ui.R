
sidebar_setup <- tribble(
 ~ label,            ~ var,         ~ icon_name,
 "Scores",           "vue",         "dashboard",
 "MàJ scores",       "up_scores",   "poll",
 "MàJ détails",      "up_ovalide",  "table",
 "MàJ contacts",     "up_contacts", "address-book",
 "Supprime données", "reset",       "trash")
init_menu_item <- function(label, var, icon_name) {
 menuItem(label, tabName = var,   icon = icon(icon_name))
}
sidebar <- dashboardSidebar(
 do.call(sidebarMenu, pmap(sidebar_setup, init_menu_item)))

vue_tab_item <- tabItem("vue", DTOutput("scores"))
upload_tab_items_setup <- tribble(
 ~ tabName,    ~ var,      ~ label,
 "up_scores",   "fi_scores",   "Téléversez les scores",
 "up_ovalide",  "fi_ovalide",  "Téléversez les tableaux OVALIDE",
 "up_contacts", "fi_contacts", "Téléversez les contacts"
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

reset_tab_item <- tabItem("reset", actionButton("reset_action", "Reset"))

body <- dashboardBody(do.call(tabItems,
                              c(list(vue_tab_item),
                                list_upload_tab_items,
                                list(reset_tab_item))))

ui <- dashboardPage(
 dashboardHeader(title = "DILAVO"),
 sidebar,
 body)
