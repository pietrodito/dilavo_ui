prepare_list_tabItems <- function(CHAMP, STATUT) {

 nullify <- function(fn) function(...) {
  args <- list(...)
  if(is.null(args[[1]])) NULL else fn(...)
 }

 create_tabItem <- function(text,
                            icon_name,
                            tabName,
                            tabItemClass,
                            init_params) {
  Builder <- TabItemBuilder$subClass(tabItemClass)
  args <- c(list(champ = CHAMP, statut = STATUT, tabName = tabName),
            init_params %>% (nullify(flatten)))
  builder <- do.call(Builder$new, args)
  builder$produce_tabItem()
 }

 pmap(subItems_setup, create_tabItem)
}


make_body <- function() {
 ((
  items_setup
  %>% select(CHAMP, STATUT)
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
