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
            ~ text,        ~ tabName, ~ icon_name,
   "Récap. Scores",          "dash", "dashboard",
      "MàJ Scores",    "maj_scores",  "file-pen",
    "MàJ Tableaux",      "maj_tabs",  "file-csv",
    "MàJ contacts",   "maj_contact",        "at",
"Score → Tableaux",   "map_scr_tab",      "link",
 "Supprime Données",        "reset",     "trash")
