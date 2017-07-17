options(shiny.usecairo = FALSE)

library(rvest)
library(curl)
library(stringr)
library(leaflet)
library(plotly)
library(shiny)
library(dplyr)
library(shinyjs)

source("./funcs.R")

indeed_url <- "https://www.indeed.com/jobs?q="
