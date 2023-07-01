# library(dbplyr)
# library(tidyverse)
#
# con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
#
# champ <- "mco"
# statut <- "dgf"
# (ovalide_dir      <- str_c("data/", champ, "_", statut, "/ovalide/" ))
# (zip_file_path    <- str_c(ovalide_dir, "ovalide.zip"))
# (unzipped_tab_dir <- str_c(ovalide_dir, "tabs/"))
#
# unzip_ovalide_file <- function() {
#  system(paste("mkdir -p", unzipped_tab_dir, ";",
#               "unzip", zip_file_path, "-d", unzipped_tab_dir))
# }
#
# unzip_ovalide_file()
#
# file.remove(paste0(unzipped_tab_dir, "/LisezMoi.txt"))
#
# suppress_files_prefixes <- function() {
#
#  prefixe_file_pattern <- ".*\\d{4}\\.\\d\\d?\\."
#
#  produces_new_names_without_prefixe <- function() {
#   (
#    unzipped_tab_dir
#    %>% list.files
#    %>% tibble(original = .)
#    %>% mutate(new = str_remove(original, prefixe_file_pattern),
#               different = new != original)
#    %>% filter(different)
#    %>% select(original, new)
#   )
#  }
#
#  rename_file <- function(original, new) {
#   system(str_c("mv ",
#                unzipped_tab_dir, "/", original, " ",
#                unzipped_tab_dir, "/", new))
#  }
#
#  (
#   produces_new_names_without_prefixe()
#   %>% pwalk(rename_file)
#  )
# }
#
# suppress_files_prefixes()
#
#
# grab_all_names_from_files <- function() {
#  (
#   unzipped_tab_dir
#   %>% list.files
#   %>% str_remove("_\\d\\d?\\.csv$")
#   %>% unique()
#  )
# }
#
# (names <- grab_all_names_from_files())
#
# nom_complet_tableau <- "Tableau [1.D.2.MS]"
# nom_complet_tableau <- "Tableau [1.D.2.POSTCOV]"
#
# read_rds("./data/mco_dgf/scores/column_codes.rds")
#
# fichiers_correspondants <- function(nom_complet_tableau) {
#
#  print(nom_complet_tableau)
#  nom_fichier_correspondant <- function() {
#
#   simplifie_nom_complet_tableau <- function(nom_complet_tableau) {
#    (
#     nom_complet_tableau
#     %>% str_replace("Tableau ", "t")
#     %>% str_remove_all("[\\[|\\]|\\.]")
#     %>% str_to_lower()
#    )
#   }
#
#   (nom_simple <- simplifie_nom_complet_tableau(nom_complet_tableau))
#   matches <- names %>% keep(function(name) {str_detect(nom_simple, name)})
#   if(length(matches) != 1) {
#    print(matches)
#    stop(paste("Il n'existe pas un et unique type de fichier pour ce tableau"))
#
#   }
#   matches
#  }
#
#  (
#   ovalide_dir
#   %>% list.files
#   %>% keep(~ str_detect(., nom_fichier_correspondant()))
#  )
# }
#
# (
#  noms_tableaux
#  %>% map(fichiers_correspondants)
# )
#
# #fichiers_correspondants("Tableau [1.D.2.SAE]")
