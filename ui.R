source("./global.R")

shinyUI(fluidPage(
  
  # Application title
  titlePanel(title="jobseekeR- A simple job search web application.",windowTitle = "jobseekeR"),
  
  sidebarLayout(
    sidebarPanel(
            shinyjs::useShinyjs(),
            textInput(inputId = "title" ,label = "Job Position:",value = "",placeholder = "position"),
            h3(id="h3-1","Choose One Platform:"),
            hr(id="hr1"),
            actionButton(inputId="indeed",label=img(src = "indeed_logo.png",height = "100%",width="100%"),width="100%"),
            hr(id="hr2"),
            actionButton(inputId="glassdoor",label=img(src = "glassdoor_logo.png",height = "100%",width="100%"),width="100%"),
            conditionalPanel(
                  condition = "input.indeed%2==1",
                  hidden(h3(id="h3-1","Choose One Platform:")),
                  hidden(actionButton(inputId="indeed",label=img(src = "indeed_logo.png",height = "100%",width="100%"),width="100%")),
                  hidden(hr(id="hr1")),
                  hidden(actionButton(inputId="glassdoor",label=img(src = "glassdoor_logo.png",height = "100%",width="100%"),width="100%")),
                  hidden(hr(id="hr2")),
                  h3("Choose Your Filters:"),
                  uiOutput("salaryOptions"),
                  uiOutput("jobTypeOptions"),
                  uiOutput("locOptions"),
                  uiOutput("compsOptions"),
                  uiOutput("expOptions")
            ),
            width = 3
    ),

    # show data and figures
    mainPanel(
            conditionalPanel(condition = "input.indeed%2==1",
                           imageOutput("indeed_pic",height = "30px"),
                           hr(),
                           # tableOutput("search_link"),
                           textOutput("search_url"),
                           dataTableOutput(outputId = "job_list"))
    )
  )
))
