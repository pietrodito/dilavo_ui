source("R/load_packages.R")

log_2_file <- FALSE
log_file <- "./logs/server.txt"

options(shiny.maxRequestSize=30*1024^2)
possible_mapping_number <- 20

## Common tools --------------
source("R/log_helper.R")
str_under <- function(...) str_c(..., sep = "_")
source("R/score_table_tools.R")
source("R/parse_js_file.R")
source("R/unzip_ovalide_file.R")


## UI -------------------------
source("R/ui_setup.R")
source("R/ui_dashboardHeader.R")
source("R/ui_dashboardSidebar.R")
source("R/ui_dashboardBody.R")


source("R/setup_dirs.R")
