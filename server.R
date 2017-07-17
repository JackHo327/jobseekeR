
shinyServer(function(input, output, session) {
      
      observeEvent(input$indeed, {
            
            toggle("glassdoor")
            toggle("indeed")
            toggle("hr1")
            toggle("hr2")
            toggle("h3-1")
            
      })
      
      job_title <- reactive({
            
            input$title
            
      })

      indeed_web <- reactive({
            
            
            w <- get_web(url = indeed_url, search_contents = job_title())
            w
            
      })
      
      # create salary option fields
      salary_search_field <- reactive({
            
            validate_component(indeed_web())
            get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Salary Estimate']/div/ul/li")
            
            
      })
      
      # render salary options
      output$salaryOptions <- renderUI({
            
            validate_component(salary_search_field())
            radioButtons(inputId = "salary", label = "Salary", choices = salary_search_field())
            
      })
      
      
      # create job type option fields
      type_search_field <- reactive({
            if (length(indeed_web()) == 0) {
                  return()
            } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
                  get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Job Type']/div/ul/li")
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
            if (length(indeed_web()) == 0) {
                  return()
            } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
                  get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Location']/div/ul/li")
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
            if (length(indeed_web()) == 0) {
                  return()
            } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
                  get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Company']/div/ul/li")
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
            if (length(indeed_web()) == 0) {
                  return()
            } else if (!is.null(indeed_web()) || !is.na(indeed_web())) {
                  # indeed_web() %>% html_nodes(xpath = "//*[@id='rb_Experience Level']/div/ul/li") %>% html_text() %>%str_replace_all(pattern = "\n", replacement = "")
                  get_web_content(web = indeed_web(), xpath = "//*[@id='rb_Experience Level']/div/ul/li")
            }
      })
      
      # render companies options
      output$expOptions <- renderUI({
            if (length(exp_search_field()) == 0) {
                  return()
            } else if (!is.null(exp_search_field()) || !is.na(exp_search_field())) {
                  radioButtons(inputId = "exps", label = "Experience Level", choices = exp_search_field())
            } else {
                  return()
            }
      })
      
      output$indeed_pic <- renderImage({
            
            return(list(src = "www/indeed_logo.png", contentType = "www/png", alt = "indeed_logo", width = 200, height = "40px", align = "left"))
            }, 
      deleteFile = FALSE)
      
      searchLink <- reactive({

            if(length(indeed_web())==0){
                  return()
            }else{
                  salarys <- data.frame(salary = salary_search_field(),stringsAsFactors = FALSE)

                  if(nrow(salarys)>0){
                        salarys$s_query <- str_replace_all(string = salary_search_field(), pattern = "\\+.*", replacement = "")
                  }
                  
                  jobtypes <- data.frame(jt = type_search_field(),stringsAsFactors = FALSE)
                  if(nrow(jobtypes)>0){
                        jobtypes$jb_query <- paste("&jt=",str_replace_all(string = type_search_field(), pattern = "-|\\(|\\)|[0-9]", replacement = "") %>% str_trim() %>% tolower(),sep="")
                  }

                  locs <- data.frame(locs = loc_search_field(),stringsAsFactors = FALSE)
                  if(nrow(locs)>0){
                        locs$loc_query <- sapply(1:nrow(locs), function(x){
                              indeed_web() %>%  html_nodes(xpath = paste("//*[@id='LOCATION_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
                        }) %>% unlist()
                  }
                  
                  comps <- data.frame(comps = comp_search_field(),stringsAsFactors = FALSE)
                  if(nrow(comps)>0){
                        comps$comp_query <- sapply(1:nrow(comps), function(x){
                              indeed_web() %>%  html_nodes(xpath = paste("//*[@id='COMPANY_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
                        }) %>% unlist()
                  }
                  
                  exps <- data.frame(exper = exp_search_field(),stringsAsFactors = FALSE)
                  
                  if(nrow(exps)>0){
                        exps$exps_query <- paste("&explvl=",str_replace_all(string = exp_search_field(), pattern = "\\(|\\)|[0-9]", replacement = "") %>% str_trim() %>% str_replace(pattern = " ", replacement = "_") %>% tolower(), sep="")
                  }
                  
                  mdt<- merge(salarys, jobtypes, by =NULL) %>% merge(locs, by = NULL) %>% merge(comps, by = NULL) %>% merge(exps, by = NULL)
                  
                  mdt
            }
      })
      
      dist_link <- reactive({
            
            
            validate(
                  need(!is.na(searchLink()), "Please waiting for a moment")
            )
            
            if(is.null(searchLink())||is.na(searchLink())||nrow(searchLink())==0){
                  return()
            }else{
                  paste(indeed_url,job_title() %>% str_trim() %>% str_replace(pattern = " ", replacement = "+"),"+", paste(searchLink()[with(searchLink(),which(salary == input$salary& jt == input$jobtype& locs == input$locs& comps == input$comps& exper == input$exps)),c(2,4,6,8,10)] ,collapse = ""),sep="")
            }
            
      })
      
      output$search_url <- renderText({

            dist_link()
            
      })
      
      
      jobs <- reactive({

            
            
      })
      
      
      output$job_list <- renderDataTable({
            jobs()
            
            validate(
                  need(!is.null(jobs())||!is.na(jobs()), "Please select you filters")
            )
            
            jobs()
      })

})