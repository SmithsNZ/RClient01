#Ctrl Enter to run selection
#workspace session data saved to .RData file, commands saved to .Rhistory file in current directory

# installed.packages()
# last package loaded wins conflicts - can detach
# conflicts(detail = TRUE)
# getAnywhere(x="show")
# x = "show" 
# names(which(sapply(search(), FUN = function(env) exists(x, env, inherits = FALSE, mode = "function"))))

# summary(RFS) # stats
# str(RFS)
# head(RFS) #top
# View(RFS) #graphical matrix view
# objects() # or ls()
# rm(res) #remove object from workspace

# install.packages("readr")      # csv support
# install.packages("tidyverse")  # tibbles, data pliers, pipes
# install.packages("tidytext")   # sentiment analysis
# install.packages("RODBC")      # ODBC sql

library(readr) 
library(tidyverse)
library(tidytext)
library(RODBC)

# spec_tsv("c:\\data\\RFSData01.txt")
RFS <- read_tsv("c:\\data\\RFSData01.txt") 

View(RFS)
str(RFS)

db <- odbcDriverConnect('driver={SQL Server};server=ccosqlbidi01;database=WA02Stage;trusted_connection=true')

# get data from sql view: RFSNumber, RFSTypeCode, RTSText
RFS <- sqlQuery(db, 'select * from RFSData01', stringsAsFactors= FALSE)
RFS <- as_tibble(RFS)

glimpse(RFS)
distinct(RFS, RFSTypeCode)
RFS %>% group_by(RFSTypeCode) %>% summarise(TypeCount=n())

#fn(tbl, output col, input col) defaults to word grain, keeps other cols, lcased
unnest_tokens(RFS, word, RFSText)

glimpse(unnest_tokens(RFS, word, RFSText))
unnest_tokens(RFS, word, RFSText) %>% group_by(RFSNumber, RFSTypeCode) %>% summarise(TypeCount=n())


glimpse(sentiments)
summary(sentiments)
sentiments # df of 3 seperate lexicons of words and sentiments

get_sentiments("afinn") # return entries for lexicon name
summary(get_sentiments("afinn"))
count(get_sentiments("afinn")