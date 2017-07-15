# only for testing.
# only for testing.
# only for testing.
# only for testing.
# only for testing.

job_position <- "data scientist" %>% str_replace(pattern = " ",replacement = "+")

# url_ <- "https://www.indeed.com/jobs?q=data+scientist+$50,000&rbc=Mount+Sinai+Health+System&rbl=New+York,+NY&jcid=c007936ceb766fe5&jlid=45f6c4ded55c00bf&jt=fulltime&explvl=mid_level"

url<-paste("https://www.indeed.com/jobs?q=",job_position,"&l=", sep="")

urltp <-"https://www.indeed.com/jobs?q=data+scientist+$50,000&jt=fulltime"

web <- read_html(curl(urltp, handle = curl::new_handle("useragent" = "Mozilla/5.0")))
# web <- read_html(curl(urltp, handle = curl::new_handle("useragent" = "Chrome/59.0.3071.115")))

# salary estimate options
web %>%  html_nodes(xpath = "//*[@id='rb_Salary Estimate']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# job type options
web %>%  html_nodes(xpath = "//*[@id='rb_Job Type']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# locs options
web %>%  html_nodes(xpath = "//*[@id='rb_Location']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# companies options
web %>%  html_nodes(xpath = "//*[@id='rb_Company']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# experience level options
web %>%  html_nodes(xpath = "//*[@id='rb_Experience Level']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# job title
web %>%  html_nodes(xpath = "//*[@id='resultsCol']/div/h2") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

web %>%  html_nodes(xpath = "//*[@class='  row  result']/h2") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# companies name
web %>%  html_nodes(xpath = "//*[@id='resultsCol']/div/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="") %>% str_trim()

web %>%  html_nodes(xpath = "//*[@class='company']/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")%>% str_trim()


# //*[@id="p_b2cac198ac757d5c"]
# 
# //*[@id="resultsCol"]

# //*[@id="jl_74660463c3e3ffbe"]/a
# //*[@id="p_6b97839a8ceb3ab3"]

# //*[@id="p_74660463c3e3ffbe"]/span[1]