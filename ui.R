source("./global.R",local = TRUE)

shinyUI(fluidPage(
  
  # Application title
  titlePanel(title="jobseekeR- A simple job searching web application.",windowTitle = "jobseekeR"),
  
  tags$script('
  $(document).ready(function () {
              navigator.geolocation.getCurrentPosition(onSuccess, onError);
              
              function onError (err) {
              Shiny.onInputChange("geolocation", false);
              }
              
              function onSuccess (position) {
              setTimeout(function () {
              var coords = position.coords;
              console.log(coords.latitude + ", " + coords.longitude);
              Shiny.onInputChange("geolocation", true);
              Shiny.onInputChange("lat", coords.latitude);
              Shiny.onInputChange("long", coords.longitude);
              }, 1100)
              }
              });
              '),
  
  sidebarLayout(
    sidebarPanel(
            shinyjs::useShinyjs(),
            busyIndicator(),
            textInput(inputId = "title" ,label = "Job Position:",value = "",placeholder = "position"),
            h3(id="h3-1","Choose One Platform:"),
            hr(id="hr1"),
            shiny::actionButton(inputId="indeed",label=img(src = "indeed_logo.png",height = "100%",width="100%"),width="100%"),
            hr(id="hr2"),
            h5(id="h5-1","Glassdoor's section is under development, only indeed is open for the public use."),
            shiny::actionButton(inputId="glassdoor",label=img(src = "glassdoor_logo.png",height = "100%",width="100%"),width="100%"),
            conditionalPanel(
                  condition = "input.indeed%2==1",
                  hidden(h3(id="h3-1","Choose One Platform:")),
                  hidden(actionButton(inputId="indeed",label=img(src = "indeed_logo.png",height = "100%",width="100%"),width="100%")),
                  hidden(hr(id="hr1")),
                  hidden(h5(id="h5-1","Glassdoor's section is under development, only indeed is open for the public use.")),
                  hidden(actionButton(inputId="glassdoor",label=img(src = "glassdoor_logo.png",height = "100%",width="100%"),width="100%")),
                  hidden(hr(id="hr2","")),
                  h3("Choose Your Filters:"),
                  numericInput(inputId="num_job_search",label = "Enter the number of records you want to see:", value = 30, min = 10, step = 10),
                  uiOutput("salaryOptions"),
                  uiOutput("jobTypeOptions"),
                  uiOutput("locOptions"),
                  uiOutput("compsOptions"),
                  uiOutput("expOptions"),
                  shiny::actionButton(inputId="act_search",label ="Search", icon=icon("search",lib="glyphicon"),width = "100%")
            ),
            width = 3
    ),

    # show data and figures
    mainPanel(
          tabsetPanel(
                tabPanel("Job Positions",
                         conditionalPanel(condition = "input.indeed%2==1",
                                          imageOutput("indeed_pic1",height = "30px"),
                                          hr(),
                                          textOutput("search_url"),
                                          helpText("The table in this page will show the detailed information about the positions you selected."),
                                          dataTableOutput(outputId = "job_list")),icon = icon("modal-window",lib="glyphicon")),
                tabPanel("Employers",
                         conditionalPanel(condition = "input.indeed%2==1",
                         imageOutput("indeed_pic2",height = "30px"),
                         hr(),
                         helpText("The barplot below will show how many positions does every company which you selected have."),
                         plotlyOutput("company_plotly_hist",width = "100%", height="50%"),
                         hr(),
                         helpText("The barplot below will show how many positions does every locations (the `United States' means multi-place-hired-positions) which you selected have."),
                         plotlyOutput("locs_plotly_hist",width = "100%", height="50%")),icon=icon("user",lib="glyphicon")),
                tabPanel("Logistics",
                         conditionalPanel(condition = "input.indeed%2==1",
                         imageOutput("indeed_pic3",height = "30px"),
                         hr(),
                         helpText("The map will show your location (please allow your browser access to your location lat and lng) and where every position you searched is (the api could be called 5,000 times per day as a whole, and once it outnumbers the limitation, this function will not work)."),
                         leafletOutput("position_leaflet_locs",height=780)), icon=icon("map-marker",lib="glyphicon"))
          ),
            width = 9
    )
  )
))
