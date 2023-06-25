items_setup <- tribble(
 ~champ, ~statut, ~icon_name             ,
 "mco" , "dgf"  , "bed-pulse"            ,
 "mco" , "oqn"  , "bed-pulse"            ,
 "had" , "dgf"  , "house-chimney-medical",
 "had" , "oqn"  , "house-chimney-medical",
 "smr" , "dgf"  , "hospital"             ,
 "smr" , "oqn"  , "hospital"             ,
 "psy" , "dgf"  , "face-sad-tear"        ,
 "psy" , "oqn"  , "face-sad-tear"        )

(items_loop <- items_setup %>% select(champ, statut))

subItems_setup <- tribble(
 ~text             , ~icon_name , ~tabName    ,
 "Récap. Scores"   , "dashboard", "dash"      ,
 "MàJ Scores"      , "file-pen" , "MAJscores" ,
 "MàJ Tableaux"    , "file-csv" , "MAJtabs"   ,
 "MàJ contacts"    , "at"       , "MAJcontact",
 "Score → Tableaux", "link"     , "MAPscore"  ,
 "Supprime Données", "trash"    , "reset"     )

upload_tab_items_init_parameters <- tribble(
 ~tabName ,     ~label                           ,
 "MAJscores" ,  "Téléversez les scores"          ,
 "MAJtabs"   ,  "Téléversez les tableaux OVALIDE",
 "MAJcontact",  "Téléversez les contacts"        )
