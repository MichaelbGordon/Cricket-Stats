
install.packages(rvest)
install.packages(tidyverse)

library('rvest')
library('tidyverse')

url <- 'http://stats.espncricinfo.com/ci/engine/player/277906.html?class=1;template=results;type=batting;view=innings'
webpage <- read_html(url)

innings_table <- html_nodes(webpage, 'table')
innings_df <- html_table(innings_table,fill = TRUE)[[4]]

colnames(innings_df) <- c("Runs","Mins","BF","4s","6s","SR","Pos","Dismissal","Inns","unsure","Opposition","Ground","Start Date", "unsureagain")

runs_df <- innings_df %>% 
  select(Runs,Dismissal) %>% 
  filter(Runs != "DNB" ) %>% 
  mutate(Runs = as.numeric(gsub("[[:punct:]]", "", Runs)))

inning_numbers <- c(1:107)
runs_df <- cbind(runs_df,inning_numbers)

ggplot(runs_df,aes(y = Runs, x = inning_numbers,fill= Dismissal)) + geom_bar(stat = "identity")+
  scale_fill_brewer(palette="Spectral") + labs(title = "Williamson innings skyscraper")


