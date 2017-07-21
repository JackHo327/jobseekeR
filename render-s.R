# This file is used to create rendered UIs
# This file is used to create rendered UIs
# This file is used to create rendered UIs
# This file is used to create rendered UIs

# render salary options
output$salaryOptions <- renderUI({
      
      validate_component(salary_search_field())
      radioButtons(inputId = "salary", label = "Salary", choices = c("ALL",salary_search_field()))
      
})

# render job type options
output$jobTypeOptions <- renderUI({
      if (length(type_search_field()) == 0) {
            return()
      } else if (!is.null(type_search_field()) || !is.na(type_search_field())) {
            radioButtons(inputId = "jobtype", label = "Job Types", choices = c("ALL",type_search_field()))
      } else {
            return()
      }
})

# render locs options
output$locOptions <- renderUI({
      if (length(loc_search_field()) == 0) {
            return()
      } else if (!is.null(loc_search_field()) || !is.na(loc_search_field())) {
            selectInput(inputId = "locs", label = "Locations", choices = c("ALL",loc_search_field()))
      } else {
            return()
      }
})

# render companies options
output$compsOptions <- renderUI({
      if (length(comp_search_field()) == 0) {
            return()
      } else if (!is.null(comp_search_field()) || !is.na(comp_search_field())) {
            selectInput(inputId = "comps", label = "Companies", choices = c("ALL",comp_search_field()))
      } else {
            return()
      }
})

# render exp options
output$expOptions <- renderUI({
      if (length(exp_search_field()) == 0) {
            return()
      } else if (!is.null(exp_search_field()) || !is.na(exp_search_field())) {
            radioButtons(inputId = "exps", label = "Experience Level", choices = c("ALL",exp_search_field()))
      } else {
            return()
      }
})