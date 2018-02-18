# R for data science work

# https://r-bloggers.com

# https://blog.rstudio.com
# https://www.tidyverse.org/package
# blog.revoultionaryanalytics.com
# https://bookdown.org
# http://rstudio.com/cheatsheets

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

library(tidyverse)
# data.frame observations == rows, variables == columns
mpg # built in see ?mpg

# explore data by visualising geometric object
# ggplot creates coord system you then add layers to (like geom_point forscatter plot)
# geom fn takes mapping param to link visual aesthetic property to data variable
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy))
ggplot(data=mpg) + geom_point(mapping=aes(x=cyl, y=hwy))
ggplot(data=mpg) + geom_point(mapping=aes(x=drv, y=hwy))

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, colour=class))

ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ, y=hwy))

ggplot(data=mpg) + geom_smooth(mapping=aes(x=displ, y=hwy, colour=drv, linetype=drv))

# overlay
ggplot(data=mpg) + 
   geom_point(mapping=aes(x=displ, y=hwy)) +
   geom_smooth(mapping=aes(x=displ, y=hwy, colour=drv, linetype=drv))


# better syntax: defaults in ggplot overriden locally for mix/merge
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
# facets = subplots displaying subset of data
# pass discrete var to factet_wrap ~ means formular from vars

ggplot(data=mpg) + 
       geom_point(mapping=aes(x=displ, y=hwy)) +
       facet_wrap( ~ class, nrow=2)

ggplot(data=diamonds) +
       geom_bar(mapping=aes(x=cut))

