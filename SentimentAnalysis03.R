text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text

library(dplyr) # tibbles == df with good print, no auto factos, no row names
text_df <- data_frame(line=1:4, text=text)

install.packages("tidytext")
library(tidytext)
installed.packages()

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

/arrange/mutate/summarise/glimpse

nrc_joy <-
  get_sentiments("nrc") %>%
  filter(sentiment == "joy")

View(tokens)
glimpse(tokens)

  tokens %>%
  filter(book=="Pride & Prejudice") %>%
  inner_join(nrc_joy) %>%
  count(word, sort=TRUE)
  
# https://www.tidytextmining.com/sentiment.html#sentiment-analysis-with-inner-join
  
  get_sentiments("bing")
  
  library(dplyr)
  
  tokens %>%
    filter(book=="Pride & Prejudice") %>%
    inner_join(get_sentiments("bing")) %>%
    count(word, linenumber, bin = linenumber / 50, sentiment) %>%
    spread(sentiment, n, fill=0)
  
  
  df <- data.frame(x = c("a", "b"), y = c(3, 4), z = c(5, 6))
  df %>% spread(x, y) %>% gather(x, y, a:b, na.rm = TRUE)
  
  getAnywhere(x="spread")
