# https://www.tidyverse.org/package
# r4ds.had.co.nz/index.html
# https://blogs.msdn.microsoft.com/mlserver/2017/04/14/get-sentiment-with-a-pre-trained-model/
# https://cran.r-project.org/doc/manuals/r-devel/R-lang.pdf


dice <- c(20, 28, 12, 32, 22, 36) # number of times 1-6 rolled
chisq.test(dice) # p of getting numbers if dice was fair== 0.009, X-squared == 15, would be 0 if dice was fair!

# +, -, *, ^(**), /, %%
# <-, ==, !=, <, >, >=
# <- objects: vectors, factors, lists, data frames, matrices

# vector data types: logical, numeric, integer, character, raw, complex
class(c(1, 3.4, 2+8)) # numeric
class(c("a", "hi", "there")) #character

# automic vector == same type
# list == generic vector == different types

# auto type coerction order : null < raw< logical < integer < double < complex < character < list/pairlist < expression

class(c(TRUE, "Hi", 2.3)) # character "TRUE", "Hi", "2.3"

# vectors
a <- c(7, 15,20)
b <- c(10, 14, 21)

a+b # 17 29 41
a*b # 70 210 420
a^2+b #  59 239 421
a[2] # 15
a[c(1,3)] # 7 20
a[1:2] #7 15
a[-2] # 7 20 (-ves excluded)
a[c(T, F, T)] # 7 20 boolean mask

# factors (category / enumerated type)
shoe_sizes <-c(38, 40, 36, 42, 36, 40, 41)
factor_sizes <- factor(shoe_sizes)
# [1] 38 40 36 42 36 40 41
# Levels: 36 38 40 41 42
nlevels(factor_sizes) # 5

# list with tags
xt <- list("a" = 2.5, "b" = TRUE, "c" = 10:13)
xt[c("b","c")] # [1] T [1] 10 11 12 13
xt$c[[3]] # 12

str(xt)
typeof(xt)
length(xt)
xt

#[] returns list - index by vectors, [[]] returns value
typeof(xt[1]) #list
typeof(xt[[1]]) #double


# lapply - apply fn to each element of list and return list
lapply(xt, "[", 1) # !!wtf?
lapply(xt, length) # list
# $a
# [1] 1
# b
# [1] 1
# $c
# [1] 4

# sapply - apply fn to each element of list and return vector - like unlist(lappy()))
sapply(xt, length) #integer
# a b c 
# 1 1 4

sapply(xt, function(x) x[1]) #    a 2.5    b 1.0   c 10.0   "double" 


x <- list(2.5, TRUE, 1:3)
str(x)
x

# mappy things == use *apply fn
plyr


