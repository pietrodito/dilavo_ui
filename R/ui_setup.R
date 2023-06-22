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
