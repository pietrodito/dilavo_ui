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
             ~text,     ~tabName,  ~icon_name,
   "Récap. Scores",       "dash", "dashboard",
      "MàJ Scores",  "MAJscores",  "file-pen",
    "MàJ Tableaux",    "MAJtabs",  "file-csv",
    "MàJ contacts", "MAJcontact",        "at",
"Score → Tableaux",  "MAPscrTAB",      "link",
"Supprime Données",      "reset",     "trash")
