library(dbplyr)
library(tidyverse)

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
copy_to(con)


system("mkdir -p data/ovalide/; unzip data/ovalide.zip -d data/ovalide/")
