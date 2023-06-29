setup_dirs <- function() {
 data_sub_dirs <- c("scores",
                    "ovalide")

 (create_sub_dir_fns <- map(data_sub_dirs, function(dir_name) {
  function(dir) system(str_c("mkdir -p data/", dir, "/", dir_name))
  }))


 make_dir_name <- function(champ, statut) str_under(champ, statut)
 ((
  items_setup
  %>% select(champ, statut)
  %>% pmap(make_dir_name)
 ) -> dir_names)

 apply_fn_to_all_dir_names <- function(fn) {
  walk(dir_names, fn)
 }

 walk(create_sub_dir_fns, apply_fn_to_all_dir_names)
}
