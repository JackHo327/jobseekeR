# get web object
get_web <- function(url, search_contents){
      
      validate(
            need(!is.null(search_contents), "Please wait for a moment")
      )
      if(str_detect(string = search_contents, pattern = " ")){
            sc <- search_contents %>% str_trim() %>% str_replace(pattern = " ", replacement = "+")            
      }else{
            sc <- search_contents
      }

      URL <- paste(url, sc, "&l=", sep = "")
      
      web <- read_html(curl(URL, handle = new_handle(useragent = "Mozilla/5.0", CONNECTTIMEOUT = 120)))
      
      web
}

# scrap filters, sections and contents corresponding to the job position searched
get_web_content <- function(web, xpath){
      
     web %>% html_nodes(xpath = xpath) %>% html_text() %>% 
            str_replace_all(pattern = "\n", replacement = "")

}

# modify error message
validate_component <- function(x){
      validate(
            need(!is.null(x)&&!is.na(x), "Please wait for a moment")
      )
}

# get filtered websets
get_webs <- function(links){
      
      validate(
            need(!is.na(links), !is.null(links), "Please wait for a moment")
      )
      
      webs <- lapply(links, function(x){
            read_html(curl(x, handle = new_handle(useragent = "Mozilla/5.0", CONNECTTIMEOUT = 40)))
      })
      
      webs
}

# form tables
form_table <- function(wb){
      
      web <- wb
      
      position_titles <- web %>%  html_nodes(xpath = "//*[@id='resultsCol']/div/h2") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")
      
      position_web_pages <- paste("https://www.indeed.com", web %>%  html_nodes(xpath = "//*[@class='jobtitle']/a") %>% html_attr(name="href"),sep="")
      
      comps <- web %>%  html_nodes(xpath = "//*[@class='company']/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")%>% str_trim()
      
      comps_prof <- paste("https://www.indeed.com", web %>%  html_nodes(xpath = "//*[@class='company']") %>% html_nodes("span") %>% html_node("a") %>% html_attr("href"), sep="")
      
      locs <- web %>% html_nodes(xpath = "//*[@itemprop='jobLocation']/span/span") %>% html_text()
      
      summary <- web %>% html_nodes(xpath = "//*[@class='snip']/div/span") %>% html_text() %>% str_replace_all(pattern = "\\\n|\\/","")
      
      comps_ <- sapply(paste("<a href=", comps_prof," target='_blank' class='btn btn-primary'>", comps, "</a>", sep="" ), function(x){
            if(str_detect(string = x, pattern = 'NA')){
                  str_extract_all(string = x, pattern = "\\>.*\\<",simplify = T) %>% str_replace_all(pattern = "\\>|\\<", replacement = "")
            }else{
                  x
            }
      })
      
      dt <- data.frame(position =  paste("<a href=", position_web_pages," target='_blank' class='btn btn-primary'>", position_titles, "</a>", sep="" ),  company_name = comps_, breif_info = summary, locations = locs,position_bak = position_titles,comps_bak = comps)
      
      geos <- lapply(paste(dt$comps_bak , dt$locations, " United States",sep=", "),geocode) %>% rbindlist()
      
      dt$lat <- geos$lat
      
      dt$lng <- geos$lon
      
      dt <- unique(dt)
      
      dt
}