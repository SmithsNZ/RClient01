text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text

library(tidyverse) # tibbles == df with good print, no auto factos, no row names
text_df <- data_frame(line=1:4, text=text)

# install.packages("tidytext") # dplyr == data pliers
library(tidytext)

# installed.packages()
# last package loaded wins conflicts - can detach
# conflicts(detail = TRUE)
# getAnywhere(x="show")
# x = "show" 
# names(which(sapply(search(), FUN = function(env) exists(x, env, inherits = FALSE, mode = "function"))))

unnest_tokens(text_df, word, text)
#fn(tbl, output col, input col) defaults to word grain, keeps other cols, lcased

sentiments # df of 3 seperate lexicons of words and sentiments

get_sentiments("afinn") # return entries for lexicon name

# neutral words not present, modern source, sentence/paragraphs better as many balance off

library(janeaustenr)
library(stringr)

books_df <- austen_books()

# group by does not change data, it changes action with associated verbs
books_gby <- group_by(books_df, book)

# add cols, preserve existing 
x1 <- mutate(books_gby, 
       linenumber = row_number(),
       chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", ignore_case = TRUE))))

x2 <- ungroup(x1)

# use word as colname so that it easily joins to other datasets
tokens <- unnest_tokens(x2, word, text)

#now 1 word per row, can apply fns which perform 'by group'

# http://seananderson.ca/2014/09/13/dplyr-intro/
# todo see beginning for read file and tidy cols example
# select (data, collist) - a,b a:d 1:6 contains() starts/ends_with()
#         drops cols not listed, so use rename() to work on set 
# filter(mammals, adult_body_mass_g > 1e7)[ , 1:3]
# filter(mammals, order == "Carnivora" & adult_body_mass_g < 200)
# arrange(mammals, desc(adult_body_mass_g)[ , 1:3]
# mutate(mammals, adult_body_mass_kg = adult_body_mass_g / 1000)
#         transmute() discards other columns
# group_by optionally sets levels for summarise fns (mean..)
# head(summarise(group_by(mammals, order),
#      mean_mass = mean(adult_body_mass_g, na.rm = TRUE)))
# also sample_n/frac()
#
# group by: https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html
# breaks dataset into specified groups so following verbs apply 'by group'
# select() - no change but grouping persisted
# arrange() - no change unless .by_group=TRUE then orders by grouping
# mutatge()/filter() see rank/minx
# summarise compute summary for each group

# see vignette() !!!

# %myfunc% is r fn defn, ">" used for 'pipe'
# works as dplyr fns take df as first parameter and return df 
# actually fn1>fn2>fn3 == fn3(fn2(fn1()))
# use . as fn results substitute if not first param (eg data =.)

# todo see http://seananderson.ca/2013/10/19/reshape/
# reshapes for read and pivot betwen rows cols example (melt, cast)
# convert from df with as_tibble()

# /arrange/mutate/summarise/glimpse

nrc_joy <-
  get_sentiments("nrc") %>%
  filter(sentiment == "joy")

View(tokens)
glimpse(tokens)

# top 10
  tokens %>%
  filter(book=="Pride & Prejudice") %>%
  inner_join(nrc_joy) %>%
  count(word, sort=TRUE)
  
# https://www.tidytextmining.com/sentiment.html#sentiment-analysis-with-inner-join
  
  get_sentiments("bing")
  
  library(tidyverse) # ggplot2, tibble, tidyr, readr, purrr

  x3 <-
    tokens %>%
    filter(book=="Pride & Prejudice") %>%
    inner_join(get_sentiments("bing"), by="word") %>%
    count(word, linenumber, bin = linenumber %/% 50, sentiment) %>%
    spread(sentiment, n, fill=0) %>%
    mutate(y=positive-negative)
  
  ggplot(x3, aes(x=bin, y=y)) +
    geom_col()
  
  glimpse(x3)
  str(x3)
  count(x3, bin, y)
  
  x3 %>% 
    filter(negative==2 | positive==2)
  
  spread(x3, sentiment, n, fill=0)
  
  df <- data.frame(x = c("a", "b"), y = c(3, 4), z = c(5, 6))
  df %>% spread(x, y) %>% gather(x, y, a:b, na.rm = TRUE)
  
  getAnywhere(x="spread")
  
  library(RODBC)
  
  # db <- odbcDriverConnect('driver={SQL Server};server=ccosqlbidi01;database=WA01Warehouse;trusted_connection=true')
  
  db <- odbcDriverConnect('driver={SQL Server};server=localhost\\SQLEXPRESS;database=DataDB01;trusted_connection=true')

  load(tibble)

  ds01 <- sqlQuery(db, 'select * from Test01', stringsAsFactors=FALSE)
  ds01 <- as_tibble(ds01)
  
  glimpse(ds01)
  
  library(tidyverse) # ggplot2, tibble, tidyr, readr, purrr
  
  x3 <-
    tokens %>%
    filter(book=="Pride & Prejudice") %>%
    inner_join(get_sentiments("bing"), by="word") %>%
    count(word, linenumber, bin = linenumber %/% 50, sentiment) %>%
    spread(sentiment, n, fill=0) %>%
    mutate(y=positive-negative)
  
  ggplot(x3, aes(x=b
  
  pp <- # 122k rows
   tokens %>%
   filter(book=="Pride & Prejudice")
  
   pp_afinn <-
     pp %>%
     inner_join(get_sentiments("afinn"), by="word") %>%
     group_by(bin = linenumber %/% 80) %>%
     summarise(sentiment = sum(score)) %>%  
     mutate(method="AFINN")
   
   View(pp_afinn)
   
   pp_bing <-
     pp %>%
     inner_join(get_sentiments("bing"), by="word") %>%
     mutate(method="bing")
   
   pp_nrc <-
     pp %>%
     inner_join(get_sentiments("nrc"), by="word") %>%
     mutate(method="nrc") %>%
     filter(sentiment %in% c("positive", "negative")) %>%
     count(method, bin = linenumber %/% 80, sentiment) %>%
     spread(sentiment, n, fill=0) %>%
     mutate(y=positive-negative)
  
   

   pp_pivot <-
     pp %>%
     inner_join(get_sentiments("nrc"), by="word") %>%
     # filter(sentiment %in% c("positive", "negative")) %>%
     arrange(linenumber) %>%
     mutate(rowid=row_number(), method="nrc", score=1, bin = linenumber %/% 80) %>%
     spread(sentiment, score, fill=0)

   pp_pivot <-
     pp %>%
     inner_join(get_sentiments("nrc"), by="word") %>%
     mutate(rowid= row_number(), method= "nrc", score= 1, bin= linenumber %/% 80) %>%
     group_by(bin, sentiment) %>%
     summarise(sentiment_score= sum(score)) %>%
     spread(sentiment, sentiment_score, fill= 0) %>%
     mutate(overall= positive - negative)
       
  # https://rpubs.com/bradleyboehmke/data_wrangling looks good 
  # and https://rpubs.com/bradleyboehmke/29134 !!
    
  # filter(). arrange(), select/rename(), mutate/transmute(), sample_n/frac() 
  # group_by(), summarise(a=n(), b=sum(), c=mean()), head(arrange(), desc())
  # n_distinct(), min(), max(), mean(), sum(), sd(), median(), IQR(), first(x), last(x) and nth(x, n)
  # mutate(y=positive-negative)
   
  pp_pivot %>%
  ggplot(aes(x=bin, y=overall)) + 
    geom_col()
   
  get_sentiments("nrc")
  get_sentiments("bing")
  View(get_sentiments("afinn"))
  
  get_sentiments("bing") %>% 
    count(sentiment)
  
  pp %>%
  inner_join(get_sentiments("bing"), by="word") %>%
  count(word, sentiment, sort=TRUE)
  
  library(wordcloud)
  
  stop_words <- tibble(word= c("good","great"))
  
  # top 10
  pp %>%
    inner_join(get_sentiments("bing"), by="word") %>%
    anti_join(stop_words, by="word") %>%
    group_by(word) %>%
    summarise(wordcount= n()) %>%
    arrange(desc(wordcount)) %>%
    top_n(50) %>%
    with( wordcloud(word, wordcount, colors=c("black","Red")))
  
acast
top_n