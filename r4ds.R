# R for data science work

# https://r-bloggers.com

# https://blog.rstudio.com
# https://www.tidyverse.org/package
# blog.revoultionaryanalytics.com
# https://bookdown.org
# http://rstudio.com/cheatsheets
# https://www.datacamp.com/community/tutorials/pipe-r-tutorial

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


