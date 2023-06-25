items_setup <- tribble(
 ~CHAMP, ~STATUT, ~icon_name             ,
 "MCO" , "DGF"  , "bed-pulse"            ,
 "MCO" , "OQN"  , "bed-pulse"            ,
 "HAD" , "DGF"  , "house-chimney-medical",
 "HAD" , "OQN"  , "house-chimney-medical",
 "SMR" , "DGF"  , "hospital"             ,
 "SMR" , "OQN"  , "hospital"             ,
 "PSY" , "DGF"  , "face-sad-tear"        ,
 "PSY" , "OQN"  , "face-sad-tear"        )

(items_loop <- items_setup %>% select(CHAMP, STATUT))

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
