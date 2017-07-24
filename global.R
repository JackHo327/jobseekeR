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

source("./setMultiCores.R", local = TRUE)
