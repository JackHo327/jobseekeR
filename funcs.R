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
      
      web <- read_html(curl(URL, handle = new_handle(useragent = "Mozilla/5.0", CONNECTTIMEOUT = 20)))
      
      web
}

# scrap filters, sections and contents corresponding to the job position searched
get_web_content <- function(web, xpath){
      
     web %>% html_nodes(xpath = xpath) %>% html_text() %>% 
            str_replace_all(pattern = "\n", replacement = "")

}

# form table

form_table <- function(x){
      
}