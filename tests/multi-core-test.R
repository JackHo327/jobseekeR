links <- paste("https://www.indeed.com/jobs?q=software+developer+",seq(0,30,by=10), sep="&start=")
# get filtered websets
get_webs <- function(links){
      webs <- lapply(links, function(x){
            html_session(x) %>% read_html()
      })
      webs
}

# form tables
form_table <- function(x){
      web <- x
      # x %>% html_session() %>% read_html()
      position_titles <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2") %>% html_text(), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2") %>% html_text()) %>% str_trim()
      
      position_web_pages <- paste("https://www.indeed.com",c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2/a") %>% html_attr(name = "href"), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2/a") %>% html_attr(name = "href")),sep="")
      
      pos <- paste("<a href=", position_web_pages," target='_blank' style='font-size:10px'>", position_titles, "</a>", sep="" ) 
      
      comps <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/span[./@class='company']") %>%html_text(),web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='company']") %>% html_text()) %>% str_trim()
      
      prof <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']/span[./@class='company']") %>% html_node("a") %>% html_attr("href"), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='company']") %>% html_node("a") %>% html_attr("href"))
      
      comps_prof <- ifelse(is.na(prof), "", paste("https://www.indeed.com", prof, sep=""))
      
      locs <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']/span[./@class='location']") %>% html_text(), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='location']") %>% html_text())
      
      summ <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']//span[./@class='summary']") %>% html_text(), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']//span[./@class='summary']") %>% html_text()) %>% str_trim()
      
      comps_ <- ifelse(comps_prof == "",paste("<a href=https://www.indeed.com/companies target='_blank' style='font-size:10px'>", comps, " (No profiles be found)</a>",sep="") ,paste("<a href=", comps_prof," target='_blank' style='font-size:10px'>", comps, "</a>", sep="" ))
      
      dt <- data.frame(position = pos, company = comps_, brief_info = summ, locations = locs, position_bak=position_titles, comps_bak= comps, stringsAsFactors = FALSE)
      
      validate(
            need(nrow(dt)>0, "nrow(dt)>0")
      )
      
      geos <- lapply(paste(dt$comps_bak , dt$locations, sep=", "), function(x){
            geocode(x, source = "dsk")
      }) %>% rbindlist()
      
      dt$lat <- geos$lat
      
      dt$lng <- geos$lon
      
      dt <- unique(dt)
      
      dt
}

no_multi_core <- function(){
      
      webs <- get_webs(links = links)
      dt <- lapply(X = webs, form_table) %>% rbindlist()

      }

library(parallel)
cl <- makePSOCKcluster(rep("localhost", detectCores()))
clusterEvalQ(cl, library(stringr))
clusterEvalQ(cl, library(ggmap))
clusterEvalQ(cl,library(rvest))
clusterEvalQ(cl,library(curl))
clusterEvalQ(cl,library(shiny))
clusterEvalQ(cl,library(dplyr))
clusterEvalQ(cl,library(data.table))
# clusterExport("read_html")

form_table_multiCore <- function(x){
      
      web <- x %>% html_session() %>% read_html()
      # x %>% html_session() %>% read_html()
      
      position_titles <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2") %>% html_text(), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2") %>% html_text()) %>% str_trim()
      
      position_web_pages <- paste("https://www.indeed.com",c(web %>% html_nodes(xpath = "//*[@class='  row  result']/h2/a") %>% html_attr(name = "href"), web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/h2/a") %>% html_attr(name = "href")),sep="")
      
      pos <- paste("<a href=", position_web_pages," target='_blank' style='font-size:10px'>", position_titles, "</a>", sep="" ) 
      
      comps <- c(web %>% html_nodes(xpath = "//*[@class='  row  result']/span[./@class='company']") %>%html_text(),web %>% html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='company']") %>% html_text()) %>% str_trim()
      
      prof <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']/span[./@class='company']") %>% html_node("a") %>% html_attr("href"), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='company']") %>% html_node("a") %>% html_attr("href"))
      
      comps_prof <- ifelse(is.na(prof), "", paste("https://www.indeed.com", prof, sep=""))
      
      locs <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']/span[./@class='location']") %>% html_text(), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']/span[./@class='location']") %>% html_text())
      
      summ <- c(web %>%  html_nodes(xpath = "//*[@class='  row  result']//span[./@class='summary']") %>% html_text(), web %>%  html_nodes(xpath = "//*[@class='lastRow  row  result']//span[./@class='summary']") %>% html_text()) %>% str_trim()
      
      comps_ <- ifelse(comps_prof == "",paste("<a href=https://www.indeed.com/companies target='_blank' style='font-size:10px'>", comps, " (No profiles be found)</a>",sep="") ,paste("<a href=", comps_prof," target='_blank' style='font-size:10px'>", comps, "</a>", sep="" ))
      
      dt <- data.frame(position = pos, company = comps_, brief_info = summ, locations = locs, position_bak=position_titles, comps_bak= comps, stringsAsFactors = FALSE)
      
      validate(
            need(nrow(dt)>0, "nrow(dt)>0")
      )
      
      geos <- lapply(paste(dt$comps_bak , dt$locations, sep=", "), function(x){
            geocode(x, source = "dsk")
      }) %>% rbindlist()
      
      dt$lat <- geos$lat
      
      dt$lng <- geos$lon
      
      dt <- unique(dt)
      
      dt
}

multi_core <- function(){
      
      dt <- parLapply(cl, X = links, form_table_multiCore) %>% rbindlist()

}

library(rvest)
library(curl)
library(stringr)
library(dplyr)
library(data.table)
library(ggplot2)
library(parallel)
microbenchmark(no_multi_core(),multi_core(),times = 5) %>% autoplot()
warnings()
stopCluster(cl)

