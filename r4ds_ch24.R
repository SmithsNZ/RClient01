# https://rpubs.com/mdancho84/r4ds_chapter24
# Model Building

library(modelr)
options(na.action = na.warn)
library(tidyverse) # ggplot2, purrr, dplyr, tidyr, readr, tibble
library(lubridate)
library(nycflights13)

# why are low quality diamonds more expensive?

# ideal cheaper than fair?
ggplot(data=diamonds, aes(x=cut, y=price)) +
  geom_boxplot()

ggplot(data=diamonds, aes(x=color, y=price)) +
  geom_boxplot()

ggplot(data=diamonds, aes(x=clarity, y=price)) +
  geom_boxplot()

#price vs carat relationship

#install.packages("hexbin")
library(hexbin)

ggplot(data=diamonds, aes(x=carat, y=price)) +
  geom_hex(bins=50)

# or scatter
# ggplot(data=diamonds) + 
#  geom_point(mapping=aes(x=carat, y=price), position="jitter")

d0 <- diamonds
str(d0)

d1 <- filter(d0, carat <= 2.5) # deletes 126

# https://people.duke.edu/~rnau/411log.htm
# log2 8 = 3 - 2^3 = 8, log10 100 = 2 - 10^2 = 100, loge uses transendental # 2.718282 
# different scales but logically same for modelling, but pick for convenience and convention
# http://www.jerrydallal.com/LHSP/LHSP.HTM logs page
# logs: transformation which relatively moves big values closer and smaller values further apart
# logs transform good because:
#    stats techniques work well on single peaked, symmetric data
#    and where variability is roughtly the same
#    and where the relationship is approc linear
# Does not matter what type of log is used

# https://people.duke.edu/~rnau/Principles_and_risks_of_forecasting--Robert_Nau.pdf
# noise == independent and identically distributed random variables i.i.d.
# coefficient of correlation == strength of linear relationship between 2 vars from -1 to 1
# scatterplot matrix == array of scatterplots between all pairs of variables
# correlation matrix == array of scatterplots showing coefficient of correlation between all pairs of vars
# blurr of history == no pattern stays the same forever old data shows old pattern
# intrinstic risk = noise (random variation) beyond current explanation
#   measured by standard error of model == standard deviation of noise in predicted variable 
# parameter risk = using wrong parameter values because assumed model correct
#   measured by standard error of coefficient estimates
# standard error of the forcast incorporates instrinsic and parameter risk
#   forcast error always >= than model error getting worse as parameters move from their modelled means 
# should be quantified for honest reporting and risk based usage of forcast
# (also risk of picking wrong model!)

# residuals == errors
# http://www.jerrydallal.com/LHSP/cause.htm
# Association does not imply causation!!
# crime increasing with church of England population over time (gen pop growth)
# ww2 bombers more accurate the more enemy fighters opposing them (visibility due to cloud cover)
#
# cause and effect (calcium good for strong bones) has to be understood to see if claims are true
# need to understand what it takes to establish causality
# perfect analysis and results IF a.b.c hold. Analysis often rechecked, important assumptions often glossed over
#
# stats ok because causality established by comparing samples with single facet difference
# medicine based on observations (smoking and lung cancer based on identical twins age and cause of death)
# history discipline nearly impossible
# amateur statisticians may ignore quality of data and fit to model
# need to understand assumptions - what we don't know is importatnt
#
# causality can only by proven by demonstrating a mechanism - (identifying tabacco component which causes cancer)
# stats cannot prove causality but can show you where to look

# design study to answer research question - http://www.jerrydallal.com/LHSP/STUDY.HTM
# stats way of seeing the world - badly designed data leads to faulty results
# - if one questionncould be answered by research, what would that question be? Front Page headine?
# compare to what would happen if there was nothing - if not nthing there must be something
# often 'not typical' means some summary of the data is so extreme it is seen <5% of time when there is nothing there
# carful! - cannot apply this to other situations - it is actually very typical
# 'typical' behaviour can change between situations
#   biased coin flips of suspect coin only suspicous if coin expected to be fair
#   flipping 1000 fair coins 2 will show 65 heads statistically
#   chance of wining the lottery small - but there's always a winner

str(d1)

d1 <- mutate(d1, 
       lprice = log2(price),
       lcarat = log2(carat)) #add cols

# viz of linear after log transform
ggplot(data=d1, aes(x=lcarat, y=lprice)) +
  geom_hex(bins=50)

d1_mod <- lm(formula=lprice ~ lcarat, data=d1)              # response ~ terms (linear predictors)
d1_pred <- data_grid(data = d1, carat=seq_range(carat,20))  # create table with evenly spaced terms
d1_pred <- mutate(.data = d1_pred, lcarat=log2(carat))      # log of term for model
d1_pred <- add_predictions(data=d1_pred, model=d1_mod, var="lprice") # add prediction response from model
d1_pred <- mutate(.data = d1_pred, price=2 ^ lprice)        # retransform log of prediction to normal 

# viz prediction against original data
ggplot(data=d1, aes(x=carat, y=price)) +
  geom_hex(bins=50) +
  geom_line(data=d1_pred, color="red", size=1)

str(d1)
# add transformed residual/error from model to original dataset
# model has d1 dataset as parameter, so can't change to d2
d1 <- add_residuals(data=d1, model=d1_mod, var="lresid")

#plot linear (transformed) errors to see if we still have a pattern
ggplot(data=d1, aes(x=lcarat, y=lresid)) +
  geom_hex(bins=50)

# Residual == difference between prediction and actual
# eg model: revenue = 2.7 * Temp - 35
#    actual/observed revenue was $50 on day when temp was 30.7
#    model gives 2.7 * 30.7 - 35 = $48
#    residual = $2

# plotting against residuals removes dominating effect of carat size
# and allows correct pattern for cut, colour and clarity to show
ggplot(data=d1, aes(x=cut, y=lresid)) +   # y was price
  geom_boxplot()

ggplot(data=d1, aes(x=color, y=lresid)) + # y was price
  geom_boxplot()

ggplot(data=d1, aes(x=clarity, y=lresid)) + # y was price
  geom_boxplot()


# want to plot predicted on x vs actual or residual/error on y
ggplot(data=d1) + 
  geom_point(mapping=aes(x=lprice, y=lresid), position="jitter")