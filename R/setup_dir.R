create_data_sub_dir <- function(dir) system(str_c("mkdir -p data/", dir))
make_dir_name <- function(CHAMP, STATUT) str_c(CHAMP, STATUT, sep = "_")
(
 items_setup
 %>% select(CHAMP, STATUT)
 %>% mutate(across(everything(), str_to_lower))
 %>% pmap(make_dir_name)
 %>% walk(create_data_sub_dir)
)
