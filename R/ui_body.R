prepare_list_tabItems <- function(champ, statut) {

 flatten_not_NULL <- function(lst) if(is.null(lst)) NULL else flatten(lst)

 create_tabItem <- function(text,
                            icon_name,
                            tabName,
                            tabItemClass,
                            init_params) {
  Builder <- TabItemBuilder$subClass(tabItemClass)
  args <- c(list(champ = champ, statut = statut, tabName = tabName,
                 init_params %>% flatten_not_NULL)) %>% flatten()
  builder <- do.call(Builder$new, args)
  builder$produce_tabItem()
 }

 pmap(subItems_pattern, create_tabItem)
}


make_body <- function() {
 ((
  items_setup
  %>% select(champ, statut)
  %>% mutate(across(everything(), str_to_lower))
 ) -> tous_les_items)

 dashboardBody(
  tags$head(tags$link(rel = "stylesheet",
                      type = "text/css",
                      href = "custom.css")),
  (
   pmap(tous_les_items, prepare_list_tabItems)
   %>% flatten()
   %>% do.call(tabItems, .)
  ))
}
