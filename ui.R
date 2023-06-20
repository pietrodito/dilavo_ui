items_setup <- tribble(
 ~champ, ~statut, ~icon_name              ,
  "MCO",  "DGF" ,  "bed-pulse"            ,
  "MCO",  "OQN" ,  "bed-pulse"            ,
  "HAD",  "DGF" ,  "house-chimney-medical",
  "HAD",  "OQN" ,  "house-chimney-medical",
  "SMR",  "DGF" ,  "hospital"             ,
  "SMR",  "OQN" ,  "hospital"             ,
  "PSY",  "DGF" ,  "face-sad-tear"        ,
  "PSY",  "OQN" ,  "face-sad-tear"        )

subItems_pattern <- tribble(
            ~ text,        ~ tabName, ~ icon_name,
   "Récap. Scores",          "dash_", "dashboard",
      "MàJ Scores",    "maj_scores_",  "file-pen",
    "MàJ Tableaux",      "maj_tabs_",  "file-csv",
    "MàJ contacts",   "maj_contact_",        "at",
"Score → Tableaux",   "map_scr_tab_",      "link",
 "Supprime Données",        "reset_",     "trash")

make_subItem <- function(champ,  statut) {
 champ  <- str_to_lower(champ)
 statut <- str_to_lower(statut)
 mutate(subItems_pattern, tabName = str_c(tabName, champ, "_", statut))
}

make_menuSubItem <- function(text, tabName, icon_name) {
 menuSubItem(text, tabName, icon = icon(icon_name))
}

make_menuItem <- function(champ, statut, icon_name) {
 text <- str_c(champ, statut, sep = " ")
 tabName <- str_c(str_to_lower(champ), str_to_lower(statut), sep = "_")
 icon <- icon(icon_name, class = "fas")
 lst_subItems <- pmap(make_subItem(champ, statut), make_menuSubItem)
 all_args <- list(text = text, tabName = tabName, icon = icon, lst_subItems)
 do.call(menuItem, all_args)
}

make_sidebarMenu <- function() {
  do.call(sidebarMenu,
          pmap(items_setup, make_menuItem))
}


# vue_tab_item <- tabItem("vue", DTOutput("scores"))
# upload_tab_items_setup <- tribble(
#  ~ tabName,    ~ var,      ~ label,
#  "up_scores",   "fi_scores",   "Téléversez les scores",
#  "up_ovalide",  "fi_ovalide",  "Téléversez les tableaux OVALIDE",
#  "up_contacts", "fi_contacts", "Téléversez les contacts"
# )
# file_input_helper <- function(var, label) {
#  fileInput(var, label,
#            buttonLabel = "Parcourir...",
#            placeholder = "Aucun fichier séléctionné"
#            )
# }
# init_upload_tab_item <- function(tabName, var, label) {
#  tabItem(tabName, file_input_helper(var, label))
# }
# list_upload_tab_items <- pmap(upload_tab_items_setup, init_upload_tab_item)
#
# reset_tab_item <- tabItem("reset", actionButton("reset_action", "Reset"))


ui <- dashboardPage(
 dashboardHeader(title = "DILAVO"),
 dashboardSidebar(make_sidebarMenu()),
 dashboardBody()
)
