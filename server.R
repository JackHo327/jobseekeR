

shinyServer(function(input, output, session) {
      
      observeEvent(input$indeed, {
            
            toggle("glassdoor")
            toggle("indeed")
            toggle("hr1")
            toggle("hr2")
            toggle("h3-1")
            toggle("tabset")
            toggle("h5-1")

      })
      
      # generate reactive object
      source("./reactive-s.R",local = TRUE)
      
      # generate rendered UIs
      source("./render-s.R", local = TRUE)
      
      output$indeed_pic1 <- renderImage({
            return(list(src = "www/indeed_logo.png", contentType = "www/png", alt = "indeed_logo", width = 200, height = "40px", align = "left"))
            }, 
      deleteFile = FALSE)
      
      output$indeed_pic2 <- renderImage({
            return(list(src = "www/indeed_logo.png", contentType = "www/png", alt = "indeed_logo", width = 200, height = "40px", align = "left"))
      }, 
      deleteFile = FALSE)
      
      
      output$indeed_pic3 <- renderImage({
            return(list(src = "www/indeed_logo.png", contentType = "www/png", alt = "indeed_logo", width = 200, height = "40px", align = "left"))
      }, 
      deleteFile = FALSE)
      
      searchLink <- reactive({
            
            validate(need(exists("input"),"hello"))
            
            if(length(indeed_web())==0){
                  return()
            }else{
                  salarys <- data.frame(salary = c("ALL",salary_search_field()),stringsAsFactors = FALSE)

                  if(nrow(salarys)>1){
                        salarys$s_query <- c("ALL",str_replace_all(string = salary_search_field(), pattern = "\\+.*", replacement = ""))
                  }
                  
                  jobtypes <- data.frame(jt = c("ALL",type_search_field()),jb_query = NA, stringsAsFactors = FALSE)
                  if(nrow(jobtypes)>1){

                        jobtypes$jb_query <- c("ALL",paste("&jt=",str_replace_all(string = type_search_field(), pattern = "-|\\(|\\)|[0-9]", replacement = "") %>% str_trim() %>% tolower(),sep=""))
                        
                  }

                  locs <- data.frame(locs = c("ALL",loc_search_field()),stringsAsFactors = FALSE)
                  if(nrow(locs)>1){
                        
                        locs$loc_query <- c("ALL",sapply(1:nrow(locs), function(x){
                              indeed_web() %>%  html_nodes(xpath = paste("//*[@id='LOCATION_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
                        }) %>% unlist())
                  
                  }
                  
                  comps <- data.frame(comps = c("ALL",comp_search_field()),stringsAsFactors = FALSE)
                  if(nrow(comps)>1){
                        
                        comps$comp_query <- c("ALL",sapply(1:nrow(comps), function(x){
                              indeed_web() %>%  html_nodes(xpath = paste("//*[@id='COMPANY_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
                        }) %>% unlist())
                        
                  }
                  
                  exps <- data.frame(exper = c("ALL",exp_search_field()),stringsAsFactors = FALSE)
                  
                  if(nrow(exps)>1){
                        
                        exps$exps_query <- c("ALL",paste("&explvl=",str_replace_all(string = exp_search_field(), pattern = "\\(|\\)|[0-9]", replacement = "") %>% str_trim() %>% str_replace(pattern = " ", replacement = "_") %>% tolower(), sep=""))
                        
                  }
                  
                  mdt<- merge(salarys, jobtypes, by =NULL) %>% merge(locs, by = NULL) %>% merge(comps, by = NULL) %>% merge(exps, by = NULL)
                  
                  mdt
            }
      })
      
      dist_link <- reactive({
            
            validate(
                  need(!is.na(searchLink()) && !is.null(searchLink()) && nrow(searchLink())>2, "Please waiting for a moment or RETRY SEARCHING")
            )
            
            str_replace_all(paste(indeed_url,job_title() %>% str_trim() %>% str_replace(pattern = " ", replacement = "+"),"+", paste(searchLink()[with(searchLink(),which( salary == salary_filter() & jt == jobtype_filter() & locs == locs_filter() & comps == comps_filter() & exper == exps_filter())),c(2,4,6,8,10)] ,collapse = ""),sep=""), pattern = "ALL", replacement = "")
      })
      
      jobs <- eventReactive(input$act_search,{
            
            page_seqs <- seq(from = 0, to = (num_jobs()-10), by = 10)

            if((num_jobs()/10) > (as.integer(num_jobs()/10))){
                  page_seqs <- seq(from = 0, to = (as.integer(num_jobs()/10)-1)*10, by = 10)
            }

            links <- paste(rep(x = dist_link(),length=length(page_seqs)), page_seqs, sep = "&start=")

            # webs <- get_webs(links = links)

            # validate_component(webs)
            
            # dt <- lapply(X = webs, form_table) %>% rbindlist()
         
            # multicore computation
            dt <- parLapply(cl, links, form_table) %>% rbindlist()

            # validate_component(dt)
            
            validate(
                  need(!is.null(dt) && !is.na(dt) && nrow(dt) > 1, "Please waiting for a moment or RETRY SEARCHING")
            )
            
            dt
            # dt$brif_info <- str_replace(string = dt$brif_info, pattern = "^\\.experienceHeader.*21px\\}",replacement = "" )
      
      })
      
      output$company_plotly_hist <- renderPlotly({
            tmp <- jobs() %>% unique()
            comps_bak <- tmp$comps_bak %>% str_to_upper()
            comps_bak <- data.frame(comps_bak,stringsAsFactors = F)
            tmp <- data.frame(table(comps_bak$comps_bak), stringsAsFactors = F)
            tmp$Var1 <- as.character(tmp$Var1)
            tmp$Var1 <- factor(tmp$Var1, levels = tmp$Var1[order(tmp$Freq,decreasing = TRUE)])
            plot_ly(data=tmp, y=~Freq, x=~Var1,type = "bar")%>%layout(xaxis = list(title="",tickcolor=toRGB("blue"),tickfont=list(size=6),tickangle=15), yaxis = list(title="Count"))
      })

      output$locs_plotly_hist <- renderPlotly({
            a <- jobs() %>% unique()
            tmp <- data.frame(table(a[,4]), stringsAsFactors = F)
            tmp$Var1 <- as.character(tmp$Var1)
            tmp$Var1 <- factor(tmp$Var1, levels = tmp$Var1[order(tmp$Freq,decreasing = TRUE)])
            plot_ly(data=tmp, y=~Freq, x=~Var1,type = "bar")%>%layout(xaxis = list(title="",tickcolor=toRGB("blue"),tickfont=list(size=6),tickangle=15), yaxis = list(title="Count"))
      })

      output$position_leaflet_locs <- renderLeaflet({

            loc_data <- jobs() %>% select(position_bak, comps_bak, lat, lng)

            loc_data <- na.omit(loc_data) 
            
            loc_data <- unique(loc_data)
            
            loc_data <- loc_data %>% filter(lat != "")

            validate(
                  need(nrow(loc_data)>0,"Please wait for downloading geocodes")
            )

            loc_data <- rbind(loc_data,data.frame(position_bak="You",comps_bak="Your Current IP Address", lat=input$lat, lng=input$long))

            loc_data %>% leaflet() %>% addTiles() %>% addCircleMarkers(lng=~lng, lat=~lat,clusterOptions=markerClusterOptions(),popup = ~paste(position_bak,comps_bak,sep=" -- "),color = c(rep("blue",length=nrow(loc_data)-1),"red"))
      })
      
      output$job_list <- renderDataTable({
            
            validate(
                  need(!is.null(jobs())&&!is.na(jobs())&&nrow(jobs())>0, "Please waiting for a moment or RETRY SEARCHING")
            )
            
            jobs() %>% select(-position_bak,-comps_bak,-lat,-lng)
            
      },escape = FALSE, options = list(pageLength=12))

})