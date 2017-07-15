library(shiny)
library(shinyjs)
source("./global.R")
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("jobseekeR- A simple job search web application.",windowTitle = "jobseekeR"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(

            shinyjs::useShinyjs(),
            h2("Choose One Platform:"),
            hr(id="hr1"),
            actionButton(inputId="indeed",label=img(src = "indeed_logo.png",height = "100%",width="100%"),width="100%"),
            hr(id="hr2"),
            actionButton(inputId="glassdoor",label=img(src = "glassdoor_logo.png",height = "100%",width="100%"),width="100%"),
            conditionalPanel(
                  condition = "input.indeed%2==1",
                  hidden(hr(id="hr1")),
                  hidden(hr(id="hr2")),
                  textInput(inputId = "title" ,label = "Job Position:",value = "",placeholder = "position"),
                  uiOutput("salaryOptions"),
                  uiOutput("jobTypeOptions"),
                  uiOutput("locOptions"),
                  uiOutput("compsOptions"),
                  hidden(actionButton(inputId="glassdoor",label=img(src = "glassdoor_logo.png",height = "100%",width="100%"),width="100%")),
                  hidden(actionButton(inputId="indeed",label=img(src = "indeed_logo.png",height = "100%",width="100%"),width="100%"))
            ),
            width = 3
    ),

    # show data and figures
    mainPanel(
            
            conditionalPanel(condition = "input.indeed%2==1",
                           imageOutput("indeed_pic"),
                           hr(id="hr3"))
            
       
    )
  )
))
