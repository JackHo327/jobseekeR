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
            read_html(curl(x, handle = new_handle(useragent = "Mozilla/5.0", CONNECTTIMEOUT = 120)))
            # read_html(x)
      })
      
      webs
}

# form tables
form_table <- function(wb){
      
      web <- wb
      
      position_titles <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2") %>% html_text(), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2") %>% html_text()) %>% str_trim()
      
      position_web_pages <- paste("https://www.indeed.com",c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2/a") %>% html_attr(name = "href"), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2/a") %>% html_attr(name = "href")),sep="")
      
      pos <- paste("<a href=", position_web_pages," target='_blank' style='font-size:10px' class='btn btn-primary'>", position_titles, "</a>", sep="" ) 
      
      comps <- web %>% html_nodes(xpath = "//*[@class='company']/span") %>%html_text() %>% str_replace_all(pattern = "\\\n",replacement = "") %>% str_trim()
      
      comps_prof <- paste("https://www.indeed.com", web %>%  html_nodes(xpath = "//*[@class='company']") %>% html_nodes("span") %>% html_node("a") %>% html_attr("href"), sep="")
      
      locs <- web %>% html_nodes(xpath = "//*[@itemprop='jobLocation']/span/span") %>% html_text() %>% str_replace_all(pattern = "[0-9].*", replacement = "") %>% str_trim()
      
      summ <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/table") %>% html_table() %>% unlist() %>% str_trim() %>% str_replace_all(pattern = "\\\n.*",""),web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/table") %>% html_table() %>% unlist() %>% str_trim() %>% str_replace_all(pattern = "\\\n.*",""))
      
      comps_ <- sapply(paste("<a href=", comps_prof," target='_blank' style='font-size:10px' class='btn btn-primary'>", comps, "</a>", sep="" ), function(x){
            if(str_detect(string = x, pattern = 'NA')){
                  str_extract_all(string = x, pattern = "\\>.*\\<",simplify = T) %>% str_replace_all(pattern = "\\>|\\<", replacement = "")
            }else{
                  x
            }
      })
      
      dt <- data.frame(position = pos, company = comps_, brief_info = summ, locations = locs, position_bak=position_titles, comps_bak= comps, stringsAsFactors = FALSE)
      
      validate(
            need(nrow(dt)>0,"nrow(dt)>0")
      )
      
      geos <- lapply(paste(dt$comps_bak , dt$locations, sep=", "), function(x){
            geocode(x, source = "dsk")
            }) %>% rbindlist()
      # 
      validate_component(geos)
      # 
      dt$lat <- geos$lat
      #
      dt$lng <- geos$lon

      dt <- unique(dt)

      dt
}