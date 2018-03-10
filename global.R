options(shiny.usecairo = FALSE)

library(rvest)
library(curl)
library(stringr)
library(leaflet)
library(plotly)
library(shiny)
library(dplyr)
library(shinyjs)
library(data.table)
library(shinysky)
library(ggmap)
library(ggplot2)
library(parallel)

source("./func-s.R")

indeed_url <- "https://www.indeed.com/jobs?q="

# set up multi-core computation
# this might take several seconds because to initialize 
source("./setMultiCores.R", local = TRUE)
