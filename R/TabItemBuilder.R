library(R6)

TabItemBuilder <- R6Class("TabItemBuilder", list(

 champ       = NA,
 statut      = NA,
 tabName     = NA,
 tab_content = NA,

 initialize = function(champ, statut, tabName) {
  self$champ   = champ
  self$statut  = statut
  self$tabName = tabName
 },

 suffixe         = function() str_c("_", self$champ, "_", self$statut),
 outputId        = function() str_c(self$tabName, self$suffixe()),
 produce_tabItem = function() tabItem(self$outputId(), self$tab_content),

 print = function(...) {
  cat("Champ:\n>" , self$champ  , "\n")
  cat("Statut:\n>", self$statut , "\n")
  cat("Name:\n>"  , self$tabName, "\n")
  cat("Content\n------")
  str(self$tab_content)
 }
 )
)
## static methods
TabItemBuilder$subClass <-
 function(prefixe) eval(parse(text = str_c(prefixe, "TabItemBuilder")))

DashTabItemBuilder <- R6Class("DashTabItemBuilder",
 inherit = TabItemBuilder, list(
  initialize = function(champ, statut, tabName) {
   super$initialize(champ, statut, tabName)
   self$tab_content = DTOutput(self$outputId())
  }
 )
)

ResetTabItemBuilder <- R6Class("ResetTabItemBuilder",
 inherit = TabItemBuilder, list(
  initialize = function(champ, statut, tabName) {
   super$initialize(champ, statut, tabName)
   self$tab_content =  actionButton(self$outputId(),
                                    str_c("Reset",
                                          self$champ  %>% str_to_upper,
                                          self$statut %>% str_to_upper,
                                          sep = " "))
  }
 )
)

UploadTabItemBuilder <- R6Class("UploadTabItemBuilder",
 inherit = TabItemBuilder, list(
  initialize = function(champ, statut, tabName, label) {
   super$initialize(champ, statut, tabName)
   self$tab_content = fileInput(self$outputId(),
                                label,
                                buttonLabel = "Parcourir...",
                                placeholder = "Aucun fichier séléctionné")
  }
 )
)

MapScoreTabItemBuilder <- R6Class("MapScoreTabItemBuilder",
 inherit = TabItemBuilder, list(
  initialize = function(champ, statut, tabName) {
   super$initialize(champ, statut, tabName)
   self$tab_content = NA
  }
 )
)
