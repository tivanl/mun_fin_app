library(httr2)
library(jsonlite)
library(glue)
library(logger)
library(furrr)
library(parallel)
library(tidyverse)
source("scripts/R/get_endpoints_info.R")
source("scripts/R/get_cube_info.R")
source("scripts/R/check_na.R")
source("scripts/R/save_cube_info.R")


# get the endpoints of the cubes
endpoints <- get_endpoints_info()

# visit each endpoint and collect the data from each page
endpoints$uri %>%
  # .[!grepl("^http://municipaldata.treasury.gov.za/api/cubes/conditional_grants$", .)] %>%
  # .[!grepl("^http://municipaldata.treasury.gov.za/api/cubes/capital$", .)] %>%
  # .[!grepl("^http://municipaldata.treasury.gov.za/api/cubes/incexp$", .)] %>%
  map(
  get_cube_info
  )
# There are issues with the following cubes (I am corresponding with Openup):
#   * conditional_grants (empty lists from page 140 onward)
#   * capital (HTTP 504 Gateway Timeout)
#   * incexp (HTTP 504 Gateway Timeout)

# Save info for each variable in all downloaded cubes
save_cube_info()




