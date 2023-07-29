nettoie_nom_colonnes <- function(string) {
  replace_1.Q_by_synthese <- function(string) {
    ifelse(str_detect(string, "1\\.Q\\)"), "Synthèse", string)
  }

  remove_regex <- function(string, reg_exps) {
    result <- string

    trim_inside <- function(character_vector) {
      (
        character_vector
        %>% str_trim()
          %>% str_replace_all("[ ]+", " ")
      )
    }

    remove_one_regex <- function(regex) {
      result <<- str_remove_all(result, regex) %>% trim_inside()
    }

    walk(reg_exps, remove_one_regex)

    result
  }

  reg_exps <- c(
    "SSRHA",
    "RHA",
    "[S|s]core",
    "Séjour",
    "sej",
    "seq",
    "Qualité",
    "partie",
    "'",
    "[(|)|:]",
    "1\\.Q.*",
    "\\\"",
    "Valorisation",
    "^\\d",
    "\\d\\..",
    " \\d$",
    "\\d_D"
  )
  (
    string
    %>% replace_1.Q_by_synthese()
      %>% remove_regex(reg_exps)
      %>% str_replace("dentrée", "d'entrée")
  )
}

nettoie_nom_colonnes_psy <- function(string) {
  (
    tibble(string = string)
    %>% mutate(
        parentheses = str_extract(string, "\\(.*\\)"),
        result = ifelse(is.na(parentheses), string, parentheses)
      )
      %>% pull(result)
      %>% str_remove_all("[(|)]")
  )
}

get_column_codes <- function(string) {
  (
    string
    %>% str_extract("\\(.*\\)")
    %>% str_remove("score")
    %>% str_remove_all("[(|)]")
    %>% str_trim()
  )
}

score_path <- function(champ, statut) {
  str_c("data/", champ, "_", statut, "/scores/scores.csv")
}

score_column_codes_path <- function(champ, statut) {
  str_c("data/", champ, "_", statut, "/scores/column_codes.rds")
}

mapping_path <- function(champ, statut) {
  str_c("data/", champ, "_", statut, "/scores/mapping.csv")
}

## DEBUG & tests: ------


## load_csv <- function(champ, statut) {
##  remove_1st_and_last_column <- function(df) select(df, -c(1, ncol(df)))
##
##  path <- str_c("./draft/", champ, "_", statut, ".csv")
##  df <- suppressWarnings(suppressMessages(read_csv2(path)))
##  remove_1st_and_last_column(df)
## }
##
## explore_nom_colonne <- function(champ, statut) {
##  df <- load_csv(champ, statut)
##  names(df)
## }


## nettoie_nom_colonnes_psy(explore_nom_colonne("psy", "dgf"))
## nettoie_nom_colonnes_psy(explore_nom_colonne("psy", "oqn"))
## nettoie_nom_colonnes(explore_nom_colonne("mco", "dgf"))
## nettoie_nom_colonnes(explore_nom_colonne("mco", "oqn"))
## nettoie_nom_colonnes(explore_nom_colonne("had", "dgf"))
## nettoie_nom_colonnes(explore_nom_colonne("had", "oqn"))
## nettoie_nom_colonnes(explore_nom_colonne("ssr", "dgf"))
## nettoie_nom_colonnes(explore_nom_colonne("ssr", "oqn"))

## get_column_codes(explore_nom_colonne("mco", "dgf"))
## get_column_codes(explore_nom_colonne("mco", "oqn"))
## get_column_codes(explore_nom_colonne("had", "dgf"))
## get_column_codes(explore_nom_colonne("had", "oqn"))
## get_column_codes(explore_nom_colonne("ssr", "dgf"))
## get_column_codes(explore_nom_colonne("ssr", "oqn"))
## get_column_codes(explore_nom_colonne("psy", "dgf"))
## get_column_codes(explore_nom_colonne("psy", "oqn"))
