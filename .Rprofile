source("renv/activate.R")
renv::restore()
library(rvest)
library(dplyr)
library(stringr)
library(xml2)
library(tictoc)
library(tidyr)
library(reactable)

message("Sourcing utilities functions")

list.files(path = "R/funs", full.names = TRUE) %>% 
  lapply(., source) %>% 
  invisible()
