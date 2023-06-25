create_data_sub_dir <- function(dir) system(str_c("mkdir -p data/", dir))
make_dir_name <- function(champ, statut) str_c(champ, statut, sep = "_")
(
 items_setup
 %>% select(champ, statut)
 %>% pmap(make_dir_name)
 %>% walk(create_data_sub_dir)
)
