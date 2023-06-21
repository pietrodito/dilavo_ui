prepare_list_tabItems <- function(champ, statut) {

 ## SETUP DATA ----------------------------------------
 CHAMP  <- str_to_upper(champ)
 STATUT <- str_to_upper(statut)
 suffixe <- str_c("_", champ, "_", statut)

 upload_tab_items_setup_pattern <- tribble(
  ~tabName    ,   ~var         ,   ~label                           ,
  "MAJscores" ,   "fi_scores"  ,   "Téléversez les scores"          ,
  "MAJtabs"   ,   "fi_ovalide" ,   "Téléversez les tableaux OVALIDE",
  "MAJcontact",   "fi_contacts",   "Téléversez les contacts")

 add_suffixe_to_pattern <- function() {
  (
   upload_tab_items_setup_pattern
   %>% mutate(across(all_of(c("tabName", "var")), ~ str_c(., suffixe)))
  )
 }

 (upload_tab_items_setup <- add_suffixe_to_pattern())

 (upload_tab_items_setup_for_upload_funs <-
  bind_cols(upload_tab_items_setup_pattern[, "tabName"],
            upload_tab_items_setup[, c("var", "label")]))

 ## BODY NAMES NEEDED declared as empty
 (body_names <- str_c("body_", subItems_pattern$tabName))
 for(name in body_names) {
  eval(parse(text = str_c("assign(\"", name, "\", NULL)")))
 }

 ## BODY FUNCTIONS: dash ---------------------------------
 body_dash <-  DTOutput(str_c("scores", suffixe))

 ## BODY FUNCTIONS: uploads ---------------------------------
 file_input_helper <- function(var, label) {
  fileInput(var, label,
            buttonLabel = "Parcourir...",
            placeholder = "Aucun fichier séléctionné"
            )
 }

 create_body <- function(tabName, var, label) {
  (body_upload_name <- str_c("body_", tabName))
  eval(parse(text = str_c(
   "assign(body_upload_name,
           file_input_helper(\"", var, "\", \"", label, "\"),
          inherits = TRUE)"
              )))
 }

 pwalk(upload_tab_items_setup_for_upload_funs, create_body)

 ## BODY FUNCTIONS: dash ---------------------------------
 body_reset <-  actionButton(str_c("reset_action", suffixe),
                             str_c("Reset", CHAMP, STATUT, sep = " "))

 ## RETURN ALL TABITEMS
 make_tabItem <- function(tabName, body_name) {
  tabItem(str_c(tabName, suffixe), get(body_name))
 }

 (
  tibble(body_name = body_names)
  %>% bind_cols(subItems_pattern %>% select(tabName))
  %>% pmap(make_tabItem)
 )
}

make_body <- function() {
 ((
  items_setup
  %>% select(champ, statut)
  %>% mutate(across(everything(), str_to_lower))
 ) -> tous_les_items)

 dashboardBody(
  tags$head(tags$link(rel = "stylesheet",
                      type = "text/css",
                      href = "custom.css")),
  (
   pmap(tous_les_items, prepare_list_tabItems)
   %>% flatten()
   %>% do.call(tabItems, .)
  ))
}
