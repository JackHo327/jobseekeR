# get web object
get_web <- function(url, search_contents){
      
      if(str_detect(string = search_contents, pattern = " ")){
            sc <- search_contents %>% str_trim() %>% str_replace(pattern = " ", replacement = "+")            
      }else{
            sc <- search_contents
      }

      URL <- paste(url, sc, "&l=", sep = "")
      
      web <- URL %>% html_session() %>% read_html()

      web
}

# scrap filters, sections and contents corresponding to the job position searched
get_web_content <- function(web, xpath){
      
     web %>% html_nodes(xpath = xpath) %>% html_text() %>% str_trim()

}

# modify error message
validate_component <- function(x){
      validate(
            need(!is.null(x)&&!is.na(x), "Error occurs, please adjust your input.")
      )
}

# form tables
form_table <- function(x){
      # web <- read_html(curl(x, handle = curl::new_handle("useragent" = "Mozilla/5.0")))
      web <- x %>% html_session() %>% read_html()
      position_titles <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2") %>% html_text(), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2") %>% html_text()) %>% str_trim()
      position_web_pages <- paste("https://www.indeed.com",c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2/a") %>% html_attr(name = "href"), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2/a") %>% html_attr(name = "href")),sep="")
      pos <- paste("<a href=", position_web_pages," target='_blank' style='font-size:10px'>", position_titles, "</a>", sep="" ) 
      comps <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/span[./@class='company']") %>%html_text(),web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='company']") %>% html_text()) %>% str_trim()
      prof <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']/span[./@class='company']") %>% html_node("a") %>% html_attr("href"), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='company']") %>% html_node("a") %>% html_attr("href"))
      comps_prof <- ifelse(is.na(prof), "", paste("https://www.indeed.com", prof, sep=""))
      locs <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']/span[./@class='location']") %>% html_text(), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='location']") %>% html_text())
      summ <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']//span[./@class='summary']") %>% html_text(), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']//span[./@class='summary']") %>% html_text()) %>% str_trim()
      comps_ <- ifelse(comps_prof == "",paste("<a href=https://www.indeed.com/companies target='_blank' style='font-size:10px'>", comps, " (No profiles be found)</a>",sep="") ,paste("<a href=", comps_prof," target='_blank' style='font-size:10px'>", comps, "</a>", sep="" ))

      validate(
            need(length(comps_) > 0 & length(summ) > 0 & length(locs) > 0 & length(position_titles) > 0 & length(comps) > 0, "No results be found. Please re-format your searching requirements on the left panel.")
      )
      
      # dt <- data.frame(position = pos, company = comps_, brief_info = summ, locations = locs, position_bak=position_titles, comps_bak= comps, stringsAsFactors = FALSE)
      dt <- data.frame(position = pos, company = comps_, brief_info = summ, locations = locs, comps_bak= comps, stringsAsFactors = FALSE)
      
      validate(
            need(nrow(dt)>0, "nrow(dt)>0")
      )
      
      geos <- lapply(paste(dt$comps_bak , dt$locations, sep=", "), function(x){
            if(str_detect(x, pattern = "Remote")){
                  geocode("Nowhere Road, Dayton, PA", source = "dsk")
            }else{
                  geocode(x, source = "dsk")                  
            }
            }) 
      # print(geos)
      geos <- geos %>% rbindlist()
      dt$lat <- geos$lat
      dt$lng <- geos$lon
      dt <- unique(dt)
      dt
}