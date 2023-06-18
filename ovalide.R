library(dbplyr)
library(tidyverse)

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

ovalide_dir <- "data/ovalide"

unzip_ovalide_file <- function() {
 system(paste("mkdir -p data/ovalide/;",
              "unzip data/ovalide.zip -d", ovlaide_dir))
}

suppress_files_prefixes <- function() {
 file.remove(paste0(ovalide_dir, "/LisezMoi.txt"))
 (
  ovalide_dir
  %>% list.files
  %>% tibble(original = .)
  %>% mutate(new = str_remove(original, ".*\\d{4}\\.\\d\\d?\\."),
             different = new != original)
  %>% filter(different)
  %>% pwalk(function(original, new) {system(paste0("mv ",
                                                   ovalide_dir, "/", original,
                                                   " ",
                                                   ovalide_dir, "/", new))})
 )
}

suppress_files_prefixes()

grab_all_names_from_files <- function() {
 (
  ovalide_dir
  %>% list.files
  %>% str_remove("_\\d\\d?\\.csv$")
  %>% unique()
 )
}

(names <- grab_all_names_from_files())

nom_fichier_correspondant <- function() {

 simplifie_nom_complet_tableau <- function(nom_complet_tableau) {
  (
   nom_complet_tableau
   %>% str_replace("Tableau ", "t")
   %>% str_remove_all("[\\[|\\]|\\.]")
   %>% str_to_lower()
  )
 }

 (nom_simple <- simplifie_nom_complet_tableau(nom_complet_tableau))
 matches <- names %>% keep(function(name) {str_detect(nom_simple, name)})
 if(length(matches) != 1) {
  stop(paste("Il existe plus d'un type de fichier pour ce tableau"),
       matches)
 }
 matches
}

nom_complet_tableau <- "Tableau [1.D.2.MS]"
nom_complet_tableau <- "Tableau [1.D.2.POSTCOV]"
fichiers_correspondant <- function(nom_complet_tableau) {
 (
  ovalide_dir
  %>% list.files
  %>% keep(~ str_detect(., nom_fichier_correspondant()))
 )
}

fichiers_correspondant(nom_complet_tableau)

