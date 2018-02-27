# R for data science work

# https://r-bloggers.com

# https://blog.rstudio.com
# https://www.tidyverse.org/package
# blog.revoultionaryanalytics.com
# https://bookdown.org
# http://rstudio.com/cheatsheets
# https://www.datacamp.com/community/tutorials/pipe-r-tutorial
# http://www.cookbook-r.com/graphs

# r4ds.had.co.nz/index.html
# import wrangle (tidy+transform) visualise (surprise you) model (scale) communicate

# install.packages("tidyverse")
# package 'mnormt' successfully unpacked and MD5 sums checked
# package 'bindr' successfully unpacked and MD5 sums checked
# package 'rematch' successfully unpacked and MD5 sums checked
# package 'psych' successfully unpacked and MD5 sums checked
# package 'assertthat' successfully unpacked and MD5 sums checked
# package 'bindrcpp' successfully unpacked and MD5 sums checked
# package 'glue' successfully unpacked and MD5 sums checked
# package 'pkgconfig' successfully unpacked and MD5 sums checked
# package 'plogr' successfully unpacked and MD5 sums checked
# package 'mime' successfully unpacked and MD5 sums checked
# package 'openssl' successfully unpacked and MD5 sums checked
# package 'cellranger' successfully unpacked and MD5 sums checked
# package 'selectr' successfully unpacked and MD5 sums checked
# package 'tidyselect' successfully unpacked and MD5 sums checked
# package 'broom' successfully unpacked and MD5 sums checked
# package 'dplyr' successfully unpacked and MD5 sums checked
# package 'forcats' successfully unpacked and MD5 sums checked
# package 'haven' successfully unpacked and MD5 sums checked
# package 'httr' successfully unpacked and MD5 sums checked
# package 'hms' successfully unpacked and MD5 sums checked
# package 'modelr' successfully unpacked and MD5 sums checked
# package 'purrr' successfully unpacked and MD5 sums checked
# package 'readr' successfully unpacked and MD5 sums checked
# package 'readxl' successfully unpacked and MD5 sums checked
# package 'rvest' successfully unpacked and MD5 sums checked
# package 'tidyr' successfully unpacked and MD5 sums checked
# package 'xml2' successfully unpacked and MD5 sums checked
# package 'tidyverse' successfully unpacked and MD5 sums checked

getwd()

# VISUALISE

library(tidyverse)
# data.frame observations == rows, variables == columns
mpg # built in see ?mpg

# explore data by visualising geometric object
# ggplot creates coord system you then add layers to (like geom_point forscatter plot)
# geom fn takes mapping param to link visual aesthetic property to data variable

# scatter chart of points
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy))

# note can add 'jitter' for small random variance to stop exactly overlapping points
# less accurate but great to see large patterns emerge

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), position="jitter")

ggplot(data=mpg) + geom_point(mapping=aes(x=cyl, y=hwy))
ggplot(data=mpg) + geom_point(mapping=aes(x=drv, y=hwy))

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, colour=class))

ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ, y=hwy))

ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ, y=hwy, colour=drv, linetype=drv))

# overlay
ggplot(data=mpg) + 
   geom_point(mapping=aes(x=displ, y=hwy)) +
   geom_smooth(mapping=aes(x=displ, y=hwy, colour=drv, linetype=drv))


# better syntax: defaults in ggplot then overriden locally for mix/merge effect
ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) + 
  geom_point(mapping=aes(colour=class)) +
  geom_smooth()

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) +
  geom_smooth(mapping=aes(x=displ, y=hwy, colour=drv, linetype=drv))

ggplot(data=mpg, mapping=aes(x=displ, y=hwy)) + 
  geom_point(mapping=aes(colour=class)) +
  geom_smooth(data=filter(mpg, class =="subcompact"), se=FALSE)

# also: size, alpha (transparency), shape (max 6 default)
# plus can override value for whole graph

# facets = ordered subplots displaying subset of data
# pass discrete var to factet_wrap ~ means formular from vars

ggplot(data=mpg) + 
       geom_point(mapping=aes(x=displ, y=hwy)) +
       facet_wrap( ~ class, nrow=2)

ggplot(data=mpg) + 
  geom_point(mapping=aes(x=displ, y=hwy)) +
  facet_grid(drv ~ cyl) # use , to turn off facet for dimension (. ~ cyl)

# geoms and stats

ggplot(data=diamonds) +
       geom_bar(mapping=aes(x=cut))

# geom_bar transforms data from source to visual
# using 'count' stat(istic) by default (see ?geom_bar)
# better to explicitly state, then can specify any stat
# stats and geoms can be interchanged, both default to one type of other
# over 20 stat functions to play with -- see cheatsheet

ggplot(data=diamonds) +
  stat_count(mapping=aes(x=cut)) # same as above

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, colour=cut))

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=cut)) # colour per bar

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=clarity), position="stack") # colour stacked within bar

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=clarity), position="fill") # 100% stacked

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut, fill=clarity), position="dodge") # side by side

# flip axis to make more readable

ggplot(data=mpg, mapping=aes(x=class, y=hwy)) + 
  geom_boxplot()

ggplot(data=mpg, mapping=aes(x=class, y=hwy)) + 
  geom_boxplot() +
  coord_flip()

# ggplot template, 7 components for any plot!!!
# dataset, geom, mapping, stat, position adjustment, coord system, faceting scheme
# ggplot defaults useful except data, mappings and geoms

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

# see 3.10 in r4ds website/book
# use_snake_case for names, alt shift k for keyboard shotcuts

# TRANSFORM

# install.packages("nycflights13")

library(nycflights13)
library(tidyverse) 
# note conflicts - overwrites filter() and lg() with tidyverse versions
# would use stats::filter() and stats::lg() syntax for originals

?flights
flights

# dplyr: 
# filter()    - where, select rows, pick observations by value
# arrange()   - sort rows
# select()    - pick variables by name (rename() useful)
# mutate()    - create variables from existing vars
# summarise() - collapse vars to summary

# all can be used with group_by()
# all have format: dataframe, var arguments, new dataframe
# chain together as needed

# where
filter(flights, month==1, day==1)
filter(flights, month==11 | month == 12)
filter(flights, month %in% c(11,12)
# NA must be requested (c(1, NA, 3)) or is.na(x) | x > 1

# avoid null propagation for group bys
filter(flights, !is.na(dep_delay), !is.na(arr_delay))

# doubles cause rounding errors
# sqrt(2) ^2 == 2 FALSE     near(sqrt(2) ^2, 2) TRUE

# sort
arrange(flights, year, month, day) # NA at end
arrange(flights, desc(arr_delay))

# select cols
select(flights, year, month, day)
select(flights, year:day) #all cols between named
select(flights, -(year:day)) #all cols except named
# see starts/ends_with contains matches etc

# move to start of dataset
select(flights, time_hour, air_time, everything())

rename(flights, tail_num = tailnum)

# add/change vars (temp tables)

# new dataset from existing
flights_sml <- 
  select(flights, 
         year:day, 
         ends_with("delay"), 
         distance, 
         air_time)

# add vars
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)

# or use transmute to just keep new vars

# transmute must take vectorised functions (values are recycled)

# = x * 5 ... * / * etc %/% int division, %% remainder
# = x / sum(x) # proportion
# = x - mean(x) # difference from mean
# log2 useful for proportionalising magnitudes
# lag() / lead() like min/max
# min_rank(x), row_number(), dense_rank(), min_rank(desc(x)) 

# summarise collapses to single row

summarise(flights, delay = mean(dep_delay, na.rm=TRUE))

# better on grouped dataset rather than whole dataset

by_day <- group_by (flights, year, month, day)

summarise(by_day, delay = mean(dep_delay, na.rm=TRUE))

# note pipe symbol x %>%

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

x <- c(0.109, 0.359, 0.63, 0.17)

round(exp(diff(log(x))), 1)

# result of fn passed as first param to next fn in pipe
# use place holder dot if don't want first param
# 6 %>% round(p1, digits=.)

x %>% log() %>% diff() %>% exp() %>% round(1)

# View(flights_sml)


head(flights)
str(flights)
class (flights)

# create grouped table for other dply verbs eg summarise
by_day <- group_by (flights, year, month, day)
class(by_day)

summarise(by_day, delay = mean(dep_delay, na.rm=TRUE))  # 365 observations

by_dest <- group_by(flights, dest)

# count non-missing sum(!is.na(x)) # better to fillter out, also n_distinct(x), count()
delay <- summarise(by_dest, 
                   count=n(), 
                   dist=mean(distance, na.rm=T),
                   delay=mean(arr_delay, na.rm=T))

delay <- filter(delay, count>20, dest!="HNL")

ggplot(data=delay, mapping=aes(x=dist, y=delay)) +
      geom_point(aes(size=count), alpha=1/3) +
      geom_smooth(se=F)

not_cancelled <- filter(flights, !is.na(dep_delay), !is.na(arr_delay))
# View(not_cancelled)

by_tailNum <- group_by(not_cancelled, tailnum)

# classic arrow shape (>) as more observations reduce variance
delay2 <- summarise(by_tailNum, delay=mean(arr_delay, na.rm=T), n=n())

# filter out small observations to make overall pattern more obvious
# delay2 <- filter(delay2, n>25)

ggplot(data=delay2, mapping=aes(x=n, y=delay)) +
  geom_point(alpha=1/10)

daily <- group_by(flights, year, month, day)

(per_day <- summarise(daily, flights=n()))

(per_month <- summarise(per_day, flights=sum(flights)))

(per_year <- summarise(per_month, flights=sum(flights)))

ungroup(daily)
(summarise(daily, flights=n())) #umm

# more - see r4ds.had.co.nz 5.6 / 5.7

# EXPLORE DATA

# variation = distribution of change of continuous variable (may be errs in measurement)

# if catagorical, visualise with bar chart, numeric bin with histogram

# pattern in data shows relationship between variables

str(diamonds)
std(diamonds)

ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut))

count(diamonds, cut)

ggplot(data=diamonds) +
  geom_histogram(mapping=aes(x=carat), binwidth=0.5)

#zoom in
diamonds_small <- filter(diamonds, carat <3)

ggplot(data=diamonds_small) +
  geom_histogram(mapping=aes(x=carat), binwidth=0.1)

#and again to show pattern of sub groups!!
ggplot(data=diamonds_small, mapping=aes(x=carat)) +
  geom_histogram(binwidth=0.01)

summary(diamonds$carat)
summary(diamonds$clarity)
summary(diamonds)
ggplot(data=diamonds) +
  geom_histogram(mapping=aes(x=carat), binwidth=0.01)

# find bad data / outliers (x, y, z== dimensions of diamond)
filter(diamonds, y<3 | y>20)
# replace it with na, so does not distort aggratations
diamonds2 <- mutate(diamonds, y=ifelse(y<3 | y>20, NA, y))
summary(diamonds$y)
summary(diamonds2$y)

# can convert to flag using is.na(var) if useful data

# COVARIATION == relationship between vars (variation == withon one var)

# catagorical vs continuous
ggplot(data=diamonds, mapping=aes(x=price)) +
  geom_freqpoly(mapping=aes(colour=cut), binwidth=500)

ggplot(data=diamonds, mapping=aes(x=price)) +
  geom_bar(mapping=aes(x=cut))

# ..density.. ??

ggplot(data=diamonds, mapping=aes(x=cut, y=price)) +
  geom_boxplot()

ggplot(data=mpg, mapping=aes(x=class, y=hwy)) +
  geom_boxplot()

# reorder to see trend
ggplot(data=mpg, mapping=aes(x=reorder(class, hwy, FUN=median), y=hwy)) +
  geom_boxplot()

ggplot(data=mpg, mapping=aes(x=reorder(class, hwy, FUN=median), y=hwy)) +
  geom_boxplot() +
  coord_flip()

# cat vs cat
ggplot(data=diamonds) +
  geom_count(mapping=aes(x=cut, y=color))

diamond_heat <- count(diamonds, color, cut)

# scatter
ggplot(data=diamond_heat, mapping=aes(x=color, y=cut)) +
  geom_tile(mapping=aes(fill=n))

ggplot(data=diamonds) +
  geom_point(mapping=aes(x=carat, y=price))

# stop volume overwhelming pattern
ggplot(data=diamonds) +
  geom_point(mapping=aes(x=carat, y=price), alpha = 0.01)

# eruption length vs wait time shows pattern indicating relationship
ggplot(data=faithful) +
  geom_point(mapping=aes(x=eruptions, y=waiting), alpha = 1)


# variation increases uncertainty, covariation reduces it (7.6)
# because if 2 vars covary, you can use the value of A to better predict A

# if covariation is due to causation then A be used to control B

# models are tools to extract patterns out of data
# ================================================

# diamonds: cut vs price relationship obscured by cut vs carat and carat vs price
# can use model to remove price vs carat to see what's left
# eg fit model to predict price from carat
#       then find residuals (diff between actual and predicted price)
#       to show price of diamond without effect of carat

library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- mutate(add_residuals(diamonds, mod), resid=exp(resid))

ggplot(data=diamonds2) +
  geom_point(mapping=aes(x=carat, y=resid), alpha = 1)

# got to part 2 wrangle == ch 9 
??tibble

library(tidyverse)
library(nycflights13)

df <- tibble(
  x=runif(5),
  y=rnorm(5))

df$x
df[["x"]]
df[[1]]
# [] always return another tibble
as.data.frame(df) # for some fns which only take data frames

d = parse_date(c("12 dec 2018", "1976-12-23"))
problems(d)
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
#parse_ logical, integer, double, number(flexible), character, factor, datetime, date, time
#for when data already in character vector
#same set available as col_ fns to tll readr how to load data

charToRaw("Bob")
parse_date("01/02/15", "%m/%d/%y")  #11.3.4

#use read_csv with coltypes override if guess is not correct
#stop_with_problems aborts script on bad data

#easier to read everything as chars and type_convert/problems within data frame

challenge2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
)

type_convert(challenge2)
# see readxl and jsonlite/xml2
# write out csv, or rds (binary format) or feather library (11.5)

# gathering - convert cols to rows when reading data
# spreading -convert rows to cols
# seperate - split col into multiples
# unite - combine cols to one

planes

delay <- summarise(by_dest, 
                   count=n(), 
                   dist=mean(distance, na.rm=T),
                   delay=mean(arr_delay, na.rm=T))

delay <- filter(delay, count>20, dest!="HNL")


p2 <- count(planes,tailnum)
filter(p2, n>2)

f2 <- count(flights,year,month,day,flight)
filter(f2, n>2)

select(flights, dep_time)

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

# shared col also left, right etc
select(inner_join(x, y, by="key"), "val_x", "val_y")

# named cols
select(left_join(flights, airports, c("dest" = "faa")), "dest", "carrier")

# also set operations intersect, union, setdiff


library(stringr)
str_length("hello")
(str_c("Hi", " ", "There", " ", c("bob", "fred")))

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_extract(x, ".a.")
str_detect(x, "e")
words[str_detect(words, "[aeiou]$")]

# seq_along, str_count, str_split

library(forcats)

x1 <- c("Dec", "Apr", "Jan", "Mar")

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

y1 <- factor(x1, levels = month_levels) #if levels not supplied, taken from data 15.2
y1
sort(y1)
levels(y1)

gss_cat
count(gss_cat, race)
# use fct_recode to rename factors
# lubridate date times see ch 16

# got to 20.3
# vectors null == absence of vector, NA == absence of value in vector
# logical, integer(L), double, character (most complex wins when mixed)

# as.logical() as.integer(), as.double(), as.character()

# purr fns is_logical/integer/double/numeric/character/atomic/list/vector
#          plus is_scaler_atomic/... also checks length == 1 (single value)

# everything is a vector (no single numbers)
# tidyverse only recycles scalers, use rep fn to for recycling

x <- 1:10
# vector subsetting [c(3,4)], [c(-1, -2)] [T,F,T] eg [!is.na(x)]
c(x=1, y=2, z=3)
set_names(1:3, c("a", "b", "c"))

# can then reference with character vector x[c("a", "c")]

L = list(2, "First", c(1,2,3), list(1, c("Hi", "There")))
str(L) # str() good for lists as shows structure

# [ returns list, [[ returns single component, $name, [["a"]]

# attributes are names list of vectors attached to any object
x <- 1:10
attr(x, "greeting") <- "Hi"
attr(x, "farewell") <- "Bye"
attributes(x)

# Names, Dimensions and Classes are attributes
# generic methods call function name based on class of first argument
as.Date
methods(as.Date)

# typeof, length, + meta data -> augmented vectors
# factors (on int vectors), date/time (on numeric vectors), df & tibbles (on lists)
# is.finite(), is.infinite(), is.nan(), near

library(tidyverse)

df <- tibble(
  a=rnorm(10),
  b=rnorm(10),
  c=rnorm(10),
  d=rnorm(10)
)

median(df$a)

output <- vector("double", ncol(df)) # create empty vector

for (i in seq_along(df)) {
  output[[i]] <-median(df[[i]])
}

output  # see 21.3 for loops

# noope -- see below
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}

col_summary(df, median)

col_summary(df, mean)

# use purrr map functions instead of lappy fns (if wanted)

# map() makes a list.
# map_lgl() makes a logical vector.
# map_int() makes an integer vector.
# map_dbl() makes a double vector.
# map_chr() makes a character vector.

map_dbl(df, mean)

# keep/discard/some/every/detect/head_while/tail_while fn useful

# model objective == provide simple low dimensional summary of dataset
#                    capture true signals (patterns generated by phenomenon of interest)
#                    ignore noise

# predictive models - supervised (most common) output=model(inputs) eg y=f(x)
# (teacher/supervisor) (1) classification outputs category (eg recomendation)
#                          linear regrssion, random forest
#                      (2) regression outputs numeric (eg dollars, weight)
#                          random forest, support vector machines
#
# data discovery models - unsupervised - input but no corresponding output
# (no teacher,            models underlying structure/distribution of data
#  algorithms are on their own)                    
#                      (1) clustering groups data (eg customers by purchases)
#                          k-means
#                      (2) association find rules (eg if buy a likely to buy b)
#                          apriori
#
# semi-supervised outputs for some (expensive) but not most data (cheap) available

