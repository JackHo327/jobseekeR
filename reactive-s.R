# This file is used for create reactive objects
# This file is used for create reactive objects
# This file is used for create reactive objects
# This file is used for create reactive objects
# 
job_title <- reactive({
      input$title
})

salary_filter <- reactive({
      
      input$salary
})

jobtype_filter <- reactive({
      input$jobtype
})

locs_filter <- reactive({
      input$locs
})

comps_filter <- reactive({
      input$comps
})

exps_filter <- reactive({
      input$exps
})

num_jobs <- reactive({
      input$num_job_search
})

indeed_web <- reactive({
      validate_component(job_title())
      get_web(url = indeed_url, search_contents = job_title())
})

# create salary option fields
salary_search_field <- reactive({
      validate_component(indeed_web())
      get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Salary Estimate']/div/ul/li")
})

# create job type option fields
type_search_field <- reactive({
      if (length(indeed_web()) == 0) {
            return()
      } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
            get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Job Type']/div/ul/li")
      }
})

# create location option fields
loc_search_field <- reactive({
      if (length(indeed_web()) == 0) {
            return()
      } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
            get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Location']/div/ul/li")
      }
})

# create companies options
comp_search_field <- reactive({
      if (length(indeed_web()) == 0) {
            return()
      } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
            get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Company']/div/ul/li")
      }
})

# create experience options
exp_search_field <- reactive({
      if (length(indeed_web()) == 0) {
            return()
      } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
            get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Experience Level']/div/ul/li")
      }
})