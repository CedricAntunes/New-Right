>library(tidyverse)
library(rio) # A good package for manipulating different datasets
library(ggplot2)

populist <- import("https://populistorg.files.wordpress.com/2020/06/populist-2.0.xlsx") 

populist <- select(populist, populist:manifesto_id)

elections <- import("http://www.parlgov.org/static/data/development-utf-8/view_election.csv", encoding = "UTF-8")

elections_pop <- left_join(elections, populist, by = c("party_id" = "parlgov_id"))

elections_pop <- elections_pop %>% 
  filter(country_name=="Austria",   # Here stands and example for Austria 
         farright==1,
         eurosceptic==1,
         election_date>1990, 
         election_type=="parliament")

elections_pop <- elections_pop %>% 
  mutate(
    farright = ifelse(election_date >= farright_start & election_date <= farright_end, 1,0),)

year <- elections_pop$election_date 
  
votes <- elections_pop$vote_share

elections_pop %>% 
  ggplot(mapping = aes(year, votes)) + 
     geom_col(mapping =  aes(fill = party_name_english, group = party_name_english), width=1000, alpha=0.8) + ylim(0, 10) + facet_wrap(~ party_name_english) +
     labs(y="vote shares", fill = "Party Type", title = "Shares of far-right parties' vote shares in Austria") +
     theme_minimal()
