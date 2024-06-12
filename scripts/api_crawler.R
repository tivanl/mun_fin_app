library(httr2)
library(jsonlite)
library(glue)
library(logger)
library(furrr)
library(parallel)
library(tidyverse)
source("scripts/R/get_endpoints_info.R")
source("scripts/R/get_cube_info.R")





endpoints <- get_endpoints_info()

cl <- makePSOCKcluster(3)
plan(cluster, workers = cl)


endpoints$uri %>%
  future_map(
  get_endpoints_info
  )

stopCluster(cl)
