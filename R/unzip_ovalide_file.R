unzip_ovalide_file <- function(champ, statut) {

 (ovalide_dir      <- str_c("data/", champ, "_", statut, "/ovalide/" ))
 (zip_file_path    <- str_c(ovalide_dir, "ovalide.zip"))
 (unzipped_tab_dir <- str_c(ovalide_dir, "tabs/"))

 unzip_file <- function() {
  system(paste("mkdir -p", unzipped_tab_dir, ";",
               "unzip", zip_file_path, "-d", unzipped_tab_dir))
 }

 unzip_file()

 file.remove(paste0(unzipped_tab_dir, "/LisezMoi.txt"))

 suppress_files_prefixes <- function() {

  prefixe_file_pattern <- ".*\\d{4}\\.\\d\\d?\\."

  produces_new_names_without_prefixe <- function() {
   (
    unzipped_tab_dir
    %>% list.files
    %>% tibble(original = .)
    %>% mutate(new = str_remove(original, prefixe_file_pattern),
               different = new != original)
    %>% filter(different)
    %>% select(original, new)
   )
  }

  rename_file <- function(original, new) {
   system(str_c("mv ",
                unzipped_tab_dir, "/", original, " ",
                unzipped_tab_dir, "/", new))
  }

  (
   produces_new_names_without_prefixe()
   %>% pwalk(rename_file)
  )
 }

 suppress_files_prefixes()
}
