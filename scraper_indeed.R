# only for testing.
# only for testing.
# only for testing.
# only for testing.
# only for testing.

job_position <- "data scientist" %>% str_replace(pattern = " ",replacement = "+")

# url_ <- "https://www.indeed.com/jobs?q=data+scientist+$50,000&rbc=Mount+Sinai+Health+System&rbl=New+York,+NY&jcid=c007936ceb766fe5&jlid=45f6c4ded55c00bf&jt=fulltime&explvl=mid_level"

url<-paste("https://www.indeed.com/jobs?q=",job_position,"&start=10", sep="")

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

# job title links
paste("https://www.indeed.com/rc/clk?jk=569369e5a1607836&fccid=c007936ceb766fe5",web %>%  html_nodes(xpath = "//*[@class='jobtitle']/a") %>% html_attr(name="href"),sep="")

# # companies name
# web %>%  html_nodes(xpath = "//*[@id='resultsCol']/div/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="") %>% str_trim()

# company
web %>%  html_nodes(xpath = "//*[@class='company']/span") %>% html_text() %>% str_replace_all(pattern="\n",replacement="")%>% str_trim()

# company link
web %>%  html_nodes(xpath = "//*[@class='company']") %>% html_nodes("span") %>% html_node("a") %>% html_attr("href")
# some companies do not have length

# compnay locations
paste(comps ,web %>% html_nodes(xpath = "//*[@itemprop='jobLocation']/span/span") %>% html_text(),sep=", ")

# summary
web %>% html_nodes(xpath = "//*[@class='snip']/div/span") %>% html_text() %>% str_replace_all(pattern = "\\\n|\\/","")

### test
links <- paste("https://www.indeed.com/jobs?q=data+scientist",seq(0,40,by=10), sep="&start=")

webs <- get_webs(links = links)

bak <- lapply(webs,form_table) %>%rbindlist() 

tmp <- data.frame(table(bak$comps_bak),stringsAsFactors = F)

tmp$Var1 <- as.character(tmp$Var1)

tmp <- tmp %>% arrange(desc(Freq))

tmp$Var1 <- factor(tmp$Var1,levels= unique(tmp$Var1)[order(tmp$Freq,decreasing = T)])

plot_ly(data=tmp,x=~Var1,y=~Freq,type = "bar") %>% layout(xaxis = list(title="",tickcolor=toRGB("blue"),tickfont=list(size=10)))
      
      layout(xaxis= list(title="",tickcolor="blue",tickfont=list(size=8)),categoryarray = ~Var1, categoryorder = "array")


loc_data <- bak %>% select(position_bak, comps_bak, lat, lng)

loc_data <- na.omit(loc_data)

loc_data <- rbind(loc_data,data.frame(position_bak="You",comps_bak="Place you stay", lat=111, lng=1))

loc_data %>% leaflet() %>% addTiles() %>% addCircleMarkers(lng=~lng, lat=~lat,clusterOptions=markerClusterOptions(),popup = ~paste(position_bak,comps_bak,sep=" -- "),color = c(rep("blue",length=nrow(loc_data)-1),"red"))
