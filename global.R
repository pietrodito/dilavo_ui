library(tidyverse)
library(magrittr)
library(R6)
library(shiny)
library(shinydashboard)
library(DT)


options(shiny.maxRequestSize=30*1024^2)

## Common tools --------------
str_under <- function(...) str_c(..., sep = "_")




## UI -------------------------
source("R/ui_setup.R")
source("R/ui_dashboardHeader.R")
source("R/ui_dashboardSidebar.R")
source("R/ui_dashboardBody.R")


source("R/setup_dir.R")

