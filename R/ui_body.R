prepare_list_tabItems <- function(champ, statut) {

 subItems_pattern <- tribble(
  ~text             , ~icon_name,  ~tabName      , ~tabItemClass, ~init_params,
  "Récap. Scores"   , "dashboard", "dash"        , "Dash"       , NA          ,
  "MàJ Scores"      , "file-pen" , "MAJscores"   , "Upload"     , NA          ,
  "MàJ Tableaux"    , "file-csv" , "MAJtabs"     , "Upload"     , NA          ,
  "MàJ contacts"    , "at"       , "MAJcontact"  , "Upload"     , NA          ,
  "Score → Tableaux", "link"     , "MAPscore"    , "MapScore"   , NA          ,
  "Supprime Données", "trash"    , "reset"       , "Reset"      , NA          )

 upload_tab_items_init_parameters <- tribble(
  ~tabName ,     ~label                           ,
  "MAJscores" ,  "Téléversez les scores"          ,
  "MAJtabs"   ,  "Téléversez les tableaux OVALIDE",
  "MAJcontact",  "Téléversez les contacts"        )

 ((
  upload_tab_items_init_parameters
  %>% nest(.by = tabName, .key = "init_params")
  %>% right_join(subItems_pattern, by = "tabName", suffix = c("", ".y"))
  %>% select(- init_params.y)
 ) -> subItems_pattern)

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

prepare_list_tabItems("mco", "oqn")

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
