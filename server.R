library(shiny)
library(shinyjs)
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
      
      observeEvent(input$indeed, {
            toggle("glassdoor")
            toggle("indeed")
            toggle("hr1")
            toggle("hr2")
      })
      
      job_title <- reactive({
            input$title
      })
      
      # output$value <- renderText(job_title())
      
      web <- reactive({
            if (is.null(job_title()) || is.na(job_title())) {
                  return()
            } else if (!is.null(job_title()) || !is.na(job_title())) {
                  job_position <- job_title() %>% str_trim() %>% str_replace(pattern = " ", replacement = "+")
                  url <- paste("https://www.indeed.com/jobs?q=", job_position, "&l=", sep = "")
                  w <- read_html(curl(url, handle = new_handle(useragent = "Mozilla/5.0")))
                  w
            }
            
      })
      
      # create salary option fields
      salary_search_field <- reactive({
            if (length(web()) == 0) {
                  return()
            } else if (!is.null(web()) || !is.na(web())) {
                  web() %>% html_nodes(xpath = "//*[@id='rb_Salary Estimate']/div/ul/li") %>% html_text() %>% 
                        str_replace_all(pattern = "\n", replacement = "")
            }
      })
      
      # render salary options
      output$salaryOptions <- renderUI({
            if (length(salary_search_field()) == 0) {
                  return()
            } else if (!is.null(salary_search_field()) || !is.na(salary_search_field())) {
                  radioButtons(inputId = "salary", label = "Salary", choices = salary_search_field())
            } else {
                  return()
            }
      })
      
      
      # create job type option fields
      type_search_field <- reactive({
            if (length(web()) == 0) {
                  return()
            } else if (!is.null(web()) || !is.na(web())) {
                  web() %>% html_nodes(xpath = "//*[@id='rb_Job Type']/div/ul/li") %>% html_text() %>% str_replace_all(pattern = "\n", 
                                                                                                                       replacement = "")
            }
      })
      
      # render job type options
      output$jobTypeOptions <- renderUI({
            if (length(type_search_field()) == 0) {
                  return()
            } else if (!is.null(type_search_field()) || !is.na(type_search_field())) {
                  radioButtons(inputId = "jobtype", label = "Job Types", choices = type_search_field())
            } else {
                  return()
            }
      })
      
      
      # create location option fields
      loc_search_field <- reactive({
            if (length(web()) == 0) {
                  return()
            } else if (!is.null(web()) || !is.na(web())) {
                  web() %>% html_nodes(xpath = "//*[@id='rb_Location']/div/ul/li") %>% html_text() %>% str_replace_all(pattern = "\n", 
                                                                                                                       replacement = "")
            }
      })
      
      # render locs options
      output$locOptions <- renderUI({
            if (length(loc_search_field()) == 0) {
                  return()
            } else if (!is.null(loc_search_field()) || !is.na(loc_search_field())) {
                  selectInput(inputId = "locs", label = "Locations", choices = loc_search_field(), selected = loc_search_field()[1])
            } else {
                  return()
            }
      })
      
      
      # create companies options
      comp_search_field <- reactive({
            if (length(web()) == 0) {
                  return()
            } else if (!is.null(web()) || !is.na(web())) {
                  web() %>% html_nodes(xpath = "//*[@id='rb_Company']/div/ul/li") %>% html_text() %>% str_replace_all(pattern = "\n", 
                                                                                                                      replacement = "")
            }
      })
      
      # render companies options
      output$compsOptions <- renderUI({
            if (length(comp_search_field()) == 0) {
                  return()
            } else if (!is.null(comp_search_field()) || !is.na(comp_search_field())) {
                  selectInput(inputId = "comps", label = "Companies", choices = comp_search_field(), selected = loc_search_field()[1])
            } else {
                  return()
            }
      })
      
      
      # create experience options
      exp_search_field <- reactive({
            if (length(web()) == 0) {
                  return()
            } else if (!is.null(web()) || !is.na(web())) {
                  web() %>% html_nodes(xpath = "//*[@id='rb_Experience Level']/div/ul/li") %>% html_text() %>% 
                        str_replace_all(pattern = "\n", replacement = "")
            }
      })
      
      # render companies options
      output$compsOptions <- renderUI({
            if (length(exp_search_field()) == 0) {
                  return()
            } else if (!is.null(exp_search_field()) || !is.na(exp_search_field())) {
                  radioButtons(inputId = "exps", label = "Experience Level", choices = exp_search_field())
            } else {
                  return()
            }
      })
      
      output$indeed_pic <- renderImage({
            
            return(list(src = "www/indeed_logo.png", contentType = "www/png", alt = "indeed_logo", width = 200, 
                        height = 30, align = "left"))
            
      }, deleteFile = FALSE)
})