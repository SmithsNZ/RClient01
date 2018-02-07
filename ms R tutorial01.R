# https://docs.microsoft.com/en-gb/machine-learning-server/r/tutorial-r-to-revoscaler
# https://www.stat.berkeley.edu/~nolan/stat133/Fall05/lectures/RegEx.html
# https://www.sitepoint.com/introduction-r-rstudio/
#
# c(ombine) data  into vector
# remember linear algebra: input vector -> fn() -> output vector , any number of items in either vector ok

michelson  <- c(850, 740, 900, 1070, 930, 850, 950, 980, 980, 880, 1000, 980, 930, 650, 760, 810, 1000, 1000, 960, 960)

# and add more
michelsonNew <- c(michelson, 850, 930, 940, 970, 870)
michelsonNew

# generate 25 random numbers in normal distribution 
normalDat <- rnorm(25)
normalDat

# defaults to mean=0, standard deviation =1 which can be overriden
normalSat <- rnorm(25, mean=450, sd=100)
normalSat

# uniform distribution also common
uniformDat <- runif(25)
uniformDat

#min=0, max=1 defaults can be overridden
uniformPerc <- runif(25, min=0, max=100)
uniformPerc

#sequences common
1:10

# or use seq fn  (see RevoScalR for better big data format)
seq(length = 11, from = 10, to = 30)
seq(from = 10,length = 20, by = 4)

# visualise small data sets with plot
plot(michelson)
plot(normalDat)
plot(uniformPerc)
plot(1:10)

# stem show distribution like histogram eg take front as stem and rest as leaf and plot
# so 12, 13, 14, 26, 22 goes to 1|235 2|26

michelson
stem(michelson) 
hist(michelson) 
hist(michelson, nclass=5) # with defined groups (to match stem)
 
qqnorm(michelson) # check for normal distribution (should be straight)

boxplot(normalDat, uniformDat) # ood for comparing distributions

summary(michelson)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 650     850     940     909     980    1070 

# Note ok for small datsets but extensions like rxHistogram and rcCube support big data

rxHistogram(data=michelson)

getwd() # created txt file of data and saved in "C:/Bob/Source/RClient01"

msStats <- read.table("msStats.txt", header=TRUE) #smart unpack and col name standardisation
msStats # display dataframe data
View(msStats)

ls("package:datasets") # list built in dataframes to play with

attitude

plot(attitude)


# The first two variables (rating and complaints) show a strong linear relationship. To model that relationship, we use the lm function:

# eg use regression analysis to create linear model whereby function returns dependent variable y (response) based on independent variable(s) x1, x2 .. (predictors)
attitudeLM1 <- lm(rating ~ complaints, data=attitude)  # read ~ as depends on  -- help(lm)

summary(attitudeLM1) # show summary of model ?summary

# view together using parameters function -- ?(par) -- help (plot)
par(mfrow=c(2,2)) # setup parameters
plot(attitudeLM1)

# ms extensions for big data:
# lm : rxLinMod
# glm : rxLogit rxGlm
# kmeans : rxKmeans
# rpart : rxDTree

# Matrix (single data type)
A <- matrix(c(3, 5, 7, 9, 13, 15, 8, 4, 2), ncol=3)
A
# Arithmetic goes element by element

A+A
A*A
A %*% A # linear algebra multiplication
apply(A, 2, prod) # apply function to each element ?apply can use it to sort

#lapply - apply fn() to list
list1 <- list(x = 1:10, y = c("Tami", "Victor", "Emily"), z = matrix(c(3, 5, 4, 7), nrow=2))
list1
lapply(list1, length)

# https://docs.microsoft.com/en-gb/machine-learning-server/r/tutorial-r-to-revoscaler
#
# Microsoft ReveoScaleR functions (scalable functions which can be run locally or pushed to sql server)
# 'RevoScaleR provides the foundation for a variety of high performance, scalable data analyse'
# rxImport -- load from datasource (data installed as part of RevocaleR package)
# Full data sets available here: https://packages.revolutionanalytics.com/datasets/

list.files(rxGetOption("sampleDataDir"))
rxGetOption("sampleDataDir") # C:/Program Files/Microsoft/R Client/R_SERVER/library/RevoScaleR/SampleData
# file.path concats string collection with correct os syntax : file.path("f:", "git", "surveyor") == "f:/git/surveyor"
inDataFile <- file.path(rxGetOption("sampleDataDir"), "mortDefaultSmall2000.csv")

?mortDefaultSmall

# returns memory sized data frame, we could specify output parameter to create xdf file on disk (RxXdfData object = ms block based storage format, good for distributed processing)
mortOutput <- NULL
mortData <- rxImport(inData = inDataFile, outFile = mortOutput)

class(mortData) # data.frame
nrow(mortData)
ncol(mortData)
names(mortData)
head(mortData, n = 3)
rxGetInfo(mortData, getVarInfo = TRUE, numRows=3)

# transform data
mortDataNew <- rxDataStep(
  # Specify the input data set
  inData = mortData,
  # Put in a placeholder for an output file
  outFile = NULL,
  # Specify any variables to keep or drop
  varsToDrop = c("year"),
  # Specify rows to select
  rowSelection = creditScore < 850,
  # Specify a list of new variables to create
  transforms = list(
    catDebt = cut(ccDebt, breaks = c(0, 6500, 13000),
                  labels = c("Low Debt", "High Debt")),
    lowScore = creditScore < 625))

rxGetInfo(mortDataNew, getVarInfo = TRUE, numRows=3)

# Data frame: mortDataNew 
# Number of observations: 9982 
# Number of variables: 7 
# Variable information: 
#   Var 1: creditScore, Type: integer, Low/High: (486, 847)
# Var 2: houseAge, Type: integer, Low/High: (0, 40)
# Var 3: yearsEmploy, Type: integer, Low/High: (0, 14)
# Var 4: ccDebt, Type: integer, Low/High: (0, 12275)
# Var 5: default, Type: integer, Low/High: (0, 1)
# Var 6: catDebt
# 2 factor levels: Low Debt High Debt
# Var 7: lowScore, Type: logical, Low/High: (0, 1)
# Data (3 rows starting with row 1):
#   creditScore houseAge yearsEmploy ccDebt default   catDebt lowScore
# 1         691       16           9   6725       0 High Debt    FALSE
# 2         691        4           4   5077       0  Low Debt    FALSE

?rxGetInfo
rxHistogram(~creditScore, data = mortDataNew )

#rxCube computes category counts
mortCube <- rxCube(~F(creditScore):catDebt, data = mortDataNew)         

# line plot, 2 categories, use rxResultsDF to convert to cube output to dataframe
rxLinePlot(Counts~creditScore|catDebt, data=rxResultsDF(mortCube))

# Useful RevoScaleR analysis functions:

# rxLogit(): logistic regesssion
# rxSummary(): computing summary statistics
# rxCrossTabs(): computing cross-tabs
# rxLinMod(): estimating linear models
# rxGlm(): generalized linear models
# rxCovCor(): estimating variance-covariance or correlation matrices

# Output can be used as inputs to other R functions such as principal components analysis and factor analysis.
# calc default depending on debt and yearsEmploy
myLogit <- rxLogit(default~ccDebt+yearsEmploy , data=mortDataNew)
summary(myLogit)


# Step through again but at big data scale based on xdf format instead of in-memory (otherwise same functions)
# see https://docs.microsoft.com/en-us/machine-learning-server/r/tutorial-revoscaler-large-data-loan

# Was:
# inDataFile <- file.path(rxGetOption("sampleDataDir"), "mortDefaultSmall2000.csv")
# returns memory sized data frame, we could specify output parameter to create xdf file on disk (RxXdfData object = ms block based storage format, good for distributed processing)
# mortOutput <- NULL
# mortData <- rxImport(inData = inDataFile, outFile = mortOutput)

# note can use also getwd() and setwd() for working directory defaults

# ?Quotes for help on escape chars
dataDir <- file.path("C:", "Data", "MortData") # uses correct slash for os
list.files(dataDir) 

mortCsvFileName = file.path(dataDir, "mortDefault") # start of data file name
mortXdfFileName = file.path(dataDir, "mortDefault.xdf")
  
# loop pulling in each data file by name and appending content to xdf file
append <- "none"
for (i in 2000:2009)
{
  importFile <- paste(mortCsvFileName, i, ".csv", sep="") # "C:/Data/MortData/mortDefault2009.csv"
  mortDS <- rxImport(importFile, mortXdfFileName, append=append)
  append <- "rows"
}

rxGetInfo(mortDS, numRows=5)
rxSummary(~., data = mortDS, blocksPerRead = 2) # (blocksPerRead ignored on local client)


rxGetOption("sampleDataDir") # C:/Program Files/Microsoft/R Client/R_SERVER/library/RevoScaleR/SampleData
.Platform$file.sep


# Keep going
# https://docs.microsoft.com/en-us/machine-learning-server/r/tutorial-revoscaler-large-data-loan




#
#
#useful basics
objects() # list all objects
rm(destData_mrs, newVarInfo) # remove objects
# save(x,y,x, file="myfile.rda") load("myfile.rda") save and load to save/load variables into file
data() # show built in datasets
data("women") # load dataset
women # same as print(women)
nrow(women) #15
ncol(women) #2
summary(women) # display varies depending on type of vector - here gives stats for each numeric vector
str(women) # structure of dataset - shows class/datatype is dataframe, 15 observations (rows), 2 variables (columns)
dim(women) # 15, 2 == rows, columns
length(women) # colcount for dataets, length for vectors
Hi <- "Hello World!"
class(Hi) # class/datatype == Character

# Automic Classes : character, numeric(==float), as.numeric to coerce, use Inf for infinity eg 1/0
# ints auto coerced to numercis unless forced with as.integer or specified with L suffix 5L
# Complex for imaginary numbers, Logical for boolean (use as.logical)
# NaN == Not a number 1/0, NA = Not Available (missing)

# Higher Types (made of automic types)
# Vector = collection of elements of same type use vector function or just c(concatinate)
#        Strictly 1 dimensional, adding them merges them into one vector
# [1] in output means the next item is element number 1 -- for reference / readability, nothing to do with data

# range operator allows generation MyRange <- c(1:10)

# Lists like vectors but can hold multiple types
myList <- list(5, "Hello", "Worlds", TRUE)
myList # [[1]] means first element of list is vector [1] means fist element of vector follows
class(myList) # list
class(myList[[1]]) #numeric

# Data.Frame == Table use $ to reference columns, use women$"max head" for spaces or position women[1]
women$height # returns numeric vector, class(women$height) == numeric
# head/tail limit output to console
class(women[1]) # data.frame as part of parent
class(women[[1]]) # numeric as takes column as vector

# make data.frame
men <- data.frame(height = c(50:65), weight = c(150:165))
# names function returns/sets column names
names(men) <- c("Male Height", "Male Weight")

# Matrix = multidimensional vector (all same type)
m <- matrix(nrow = 4, ncol = 5, 1:20) # values repeated until matrix full
m
# can reshape with dim function: dim(m) <- c(3,5) or dim(m) <- NULL to return to vector
# see cbind and rbind for further functionality (data frames as well)

# Factors == vectors with labels (self describing to help R functions)
f <- factor(c("Hello", "World", "Hello", "Annie", "Hello", "World"))
f
# levels == unique elements
# table function create table with each factor as column and frequency
table(f)


#regular expressions
grep("one", c("a test", "a basic string", "and one that we want", "one two three")) 

