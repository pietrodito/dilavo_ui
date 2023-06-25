make_subItem <- function(champ,  statut) {
 (
  subItems_setup
  %>% mutate(tabName = str_c(tabName, "_", champ, "_", statut))
  %>% select(text, tabName, icon_name)
 )
}

make_menuSubItem <- function(text, tabName, icon_name) {
 menuSubItem(text, tabName, icon = icon(icon_name))
}

make_menuItem <- function(champ, statut, icon_name) {
 CHAMP  <- str_to_upper(champ)
 STATUT <- str_to_upper(statut)
 text <- str_c(CHAMP, " ", STATUT)
 tabName <- str_c(champ, "_", statut)
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
