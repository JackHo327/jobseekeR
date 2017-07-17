# only for testing.
# only for testing.
# only for testing.
# only for testing.
# only for testing.

job_position <- "data scientist" %>% str_replace(pattern = " ",replacement = "+")

# url_ <- "https://www.indeed.com/jobs?q=data+scientist+$50,000&rbc=Mount+Sinai+Health+System&rbl=New+York,+NY&jcid=c007936ceb766fe5&jlid=45f6c4ded55c00bf&jt=fulltime&explvl=mid_level"

url<-paste("https://www.indeed.com/jobs?q=",job_position,"&l=", sep="")

urltp <-"https://www.indeed.com/jobs?q=data+scientist+$50,000&jt=fulltime"

web <- read_html(curl(url, handle = curl::new_handle("useragent" = "Mozilla/5.0")))
web <- read_html(curl(urltp, handle = curl::new_handle("useragent" = "Mozilla/5.0")))
# web <- read_html(curl(urltp, handle = curl::new_handle("useragent" = "Chrome/59.0.3071.115")))

# salary estimate options
web %>%  html_nodes(xpath = "//*[@id='rb_Salary Estimate']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

salarys <- data.frame(salary = web %>%  html_nodes(xpath = "//*[@id='rb_Salary Estimate']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement=""))

salarys$s_query <- sapply(1:nrow(salarys), function(x){
      web %>%  html_nodes(xpath = paste("//*[@id='SALARY_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_replace_all(pattern = "\\/q-|-jobs.html","")%>%str_replace_all(pattern = "-",replacement = "+")
})

# job type options
web %>% html_nodes(xpath = "//*[@id='rb_Job Type']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

jobtypes <- data.frame(jt = web %>% html_nodes(xpath = "//*[@id='rb_Job Type']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement=""))

jobtypes$jb_query <- sapply(1:nrow(jobtypes), function(x){
      web %>%  html_nodes(xpath = paste("//*[@id='JOB_TYPE_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
}) %>% unlist()

# locs options
web %>%  html_nodes(xpath = "//*[@id='rb_Location']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

locs <- data.frame(locs=web %>%  html_nodes(xpath = "//*[@id='rb_Location']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement=""))
locs$loc_query <- sapply(1:nrow(locs), function(x){
      web %>%  html_nodes(xpath = paste("//*[@id='LOCATION_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
}) %>% unlist()

# companies options
web %>%  html_nodes(xpath = "//*[@id='rb_Company']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

comps <- data.frame(comps = web %>%  html_nodes(xpath = "//*[@id='rb_Company']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement=""))

comps$comp_query <- sapply(1:nrow(comps), function(x){
      web %>%  html_nodes(xpath = paste("//*[@id='COMPANY_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
}) %>% unlist()

# experience level options
web %>%  html_nodes(xpath = "//*[@id='rb_Experience Level']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

exps <- data.frame(exper = web %>%  html_nodes(xpath = "//*[@id='rb_Experience Level']/div/ul/li") %>% html_text() %>% str_replace_all(pattern="\n",replacement=""))

exps$exps_query <- sapply(1:nrow(comps), function(x){
      web %>%  html_nodes(xpath = paste("//*[@id='EXP_LVL_rbo']/ul/li[",x,"]/a",sep="")) %>% html_attr(name="href") %>% str_extract_all(pattern = "&.*",simplify = F)
}) %>% unlist()

# job title
web %>%  html_nodes(xpath = "//*[@id='resultsCol']/div/h2") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

web %>%  html_nodes(xpath = "//*[@class='  row  result']/h2") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")

# companies name
web %>%  html_nodes(xpath = "//*[@id='resultsCol']/div/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="") %>% str_trim()

web %>%  html_nodes(xpath = "//*[@class='company']/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")%>% str_trim()

# job titles
web %>%  html_nodes(xpath = "//*[@class='jobtitle']/a") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")%>% str_trim()

# job title links
web %>%  html_nodes(xpath = "//*[@class='jobtitle']/a") %>% html_attr(name="href")


# company
web %>%  html_nodes(xpath = "//*[@class='company']") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")%>% str_trim()

# company link
# web %>%  html_nodes(xpath = "//*[@class = 'company']/span") %>% html_attrs() %>% sapply(function(x){
#       if(!is.null(x)||!is.na(x)||length(x)!=0){
#             return(paste(x[[1]],"?",str_replace_all(x[[3]],pattern = "this\\.href \\= appendParamsOnce\\(this\\.href\\, \\'|\\'\\)",replacement=""),sep=""))
#       }else{
#             return(NA)
#       }
#       # x[1]
# })




# //*[@id="p_e95491e045d87177"]/span[1]