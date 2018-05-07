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

# install.packages("tidyverse")  # ggplot2, dply, tidyr, readr, purrr, tibble, stringr, forcats
# install.packages("tidytext")   # sentiment analysis
# install.packages("RODBC")      # ODBC sql

library(tidyverse) # https://www.tidyverse.org/packages/
library(tidytext)
library(RODBC)

# spec_tsv("c:\\data\\RFSData01.txt")
RFS <- read_tsv("c:\\data\\RFSData01.txt")

View(RFS)
str(RFS)

db <- odbcDriverConnect('driver={SQL Server};server=ccosqlbidi01;database=WA02Stage;trusted_connection=true')

# get data from sql view: RFSNumber, RFSTypeCode, RTSText
RFS <- sqlQuery(db, 'select * from RFSData01', stringsAsFactors= FALSE)

RFS$ID <- seq.int(nrow(RFS)) # Also see rownames_to_column() but returns chr
RFS <- as_tibble(RFS)

glimpse(RFS)
distinct(RFS, RFSTypeCode)
RFS %>% group_by(RFSTypeCode) %>% summarise(TypeCount=n())

#fn(tbl, output col, input col) defaults to word grain, keeps other cols, lcased
unnest_tokens(RFS, word, RFSText)

glimpse(unnest_tokens(RFS, word, RFSText))
unnest_tokens(RFS, word, RFSText) %>% group_by(RFSNumber, RFSTypeCode) %>% summarise(TypeCount=n())

glimpse(sentiments) # 4 lexicons of words and sentiments
sentiments %>% group_by(lexicon) %>% summarise(TypeCount=n())

get_sentiments("afinn") # return entries for lexicon name
# 1    AFINN      2476 word, score
# 2     bing      6788 word, sentiment
# 3 loughran      4149 word, sentiment
# 4      nrc     13901 word, sentiment

for (i in 1:10) {
  print(i)
  #sql <- sprintf("ID %d RFS %d", RFS$ID[i], RFS$RFSNumber[i])
  #sprintf("ID %d RFS %d", RFS$ID[i], RFS$RFSNumber[i]) # print(Sql)
}

sql <- sprintf("ID %d RFS %d", 23, 888)
sql
sql <- sprintf("ID %d RFS %d", 24, 999)
sql



sprintf("Hello %d", 6) # https://www.rdocumentation.org/packages/base/versions/3.5.0/topics/sprintf

