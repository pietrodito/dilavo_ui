make_subItem <- function(champ,  statut) {
 champ  <- str_to_lower(champ)
 statut <- str_to_lower(statut)
 mutate(subItems_pattern, tabName = str_c(tabName, "_", champ, "_", statut))
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
          c(list(id = "selected_subitem"),
            pmap(items_setup, make_menuItem)))
}

make_sidebar <- function() dashboardSidebar(make_sidebarMenu())
