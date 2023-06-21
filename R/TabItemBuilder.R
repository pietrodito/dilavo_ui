library(R6)

TabItemBuilder <- R6Class("TabItemsBuilder", list(

 champ = NA,
 statut = NA,
 tabName = NA,
 client_element = NA,

 suffixe = function() str_c(champ, "_", statut),
 produce_tabItem = function() tabItem(str_c(tabName, self$suffixe),
                                      client_element)
))

x <- TabItemBuilder$new()
y <- TabItemBuilder$new()

tibble(c(x, y))

