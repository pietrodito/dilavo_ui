items_setup <- tribble(
 ~CHAMP, ~STATUT, ~icon_name              ,
  "MCO",  "DGF" ,  "bed-pulse"            ,
  "MCO",  "OQN" ,  "bed-pulse"            ,
  "HAD",  "DGF" ,  "house-chimney-medical",
  "HAD",  "OQN" ,  "house-chimney-medical",
  "SMR",  "DGF" ,  "hospital"             ,
  "SMR",  "OQN" ,  "hospital"             ,
  "PSY",  "DGF" ,  "face-sad-tear"        ,
  "PSY",  "OQN" ,  "face-sad-tear"        )

(items_loop <- items_setup %>% select(CHAMP, STATUT))

subItems_setup <- tribble(
 ~text             , ~icon_name , ~tabName    , ~tabItemClass, ~init_params,
 "Récap. Scores"   , "dashboard", "dash"      , "Dash"       , NA          ,
 "MàJ Scores"      , "file-pen" , "MAJscores" , "Upload"     , NA          ,
 "MàJ Tableaux"    , "file-csv" , "MAJtabs"   , "Upload"     , NA          ,
 "MàJ contacts"    , "at"       , "MAJcontact", "Upload"     , NA          ,
 "Score → Tableaux", "link"     , "MAPscore"  , "MapScore"   , NA          ,
 "Supprime Données", "trash"    , "reset"     , "Reset"      , NA          )

upload_tab_items_init_parameters <- tribble(
 ~tabName ,     ~label                           ,
 "MAJscores" ,  "Téléversez les scores"          ,
 "MAJtabs"   ,  "Téléversez les tableaux OVALIDE",
 "MAJcontact",  "Téléversez les contacts"        )

(subItems_setup %<>% mutate(preserve_order = 1:nrow(subItems_setup)))
((
 upload_tab_items_init_parameters
 %>% nest(.by = tabName, .key = "init_params")
 %>% right_join(subItems_setup, by = "tabName", suffix = c("", ".y"))
 %>% arrange(preserve_order)
 %>% select(- c("init_params.y", "preserve_order"))
) -> subItems_setup)

produce_dash_subItems <- function() {

 produce_dash_item <- function(CHAMP, STATUT) {
  champ   <- str_to_lower(CHAMP)
  statut  <- str_to_lower(STATUT)
  tabName <- str_c("dash_", champ, "_", statut)
  tabItem(tabName, DTOutput(tabName))
 }
 pmap(items_loop, produce_dash_item)
}

produce_dash_subItems()


produce_reset_subItems <- function() {

 produce_reset_item <- function(CHAMP, STATUT) {
  champ   <- str_to_lower(CHAMP)
  statut  <- str_to_lower(STATUT)
  tabName <- str_c("reset_", champ, "_", statut)
  tabItem(tabName,  actionButton(tabName,
                                 str_c("Reset ", CHAMP, " " , STATUT)))
 }
 pmap(items_loop, produce_reset_item)
}

produce_reset_subItems()

## TODO keep on with MAPscore and upload items
