

datapath <- "C:\\Bob\\Data\\acllmdb\\aclImdb\\train\\pos"

fnames <- list.files(datapath)
fnames <- grep(".txt", fnames, value="TRUE")

# Sample
fnames <- sample(fnames, 100)

message(sprintf("Files found: %d", length(fnames)))

# []returns list/df [[]]returns single object
# test <- list("one", "two", "three"); test[1]; class(test[1]); test[[1]]; class(test[[1]])


nameparts <- strsplit(fnames,"[.]")  #[1] "7835_9" "txt" 

# class(nameparts[[1]][1]) == character, also unlist(nameparts) # flattens into single dim
# scoresplit <- strsplit(nameparts[[1]][1],"_")
nameparts <- nameparts[1]

fnames[[1]] # [ returns multiple via list or df, [[ return single object of class 

mortCsvFileName = file.path(dataDir, "mortDefault") # start of data file name
mortXdfFileName = file.path(dataDir, "mortDefault.xdf")



fnames=list.files("aclImdb", pattern = "[[:digit:]_]+.txt", recursive = TRUE, full.names = TRUE)

dataDir <- file.path("C:", "Data", "MortData") # uses correct slash for os

("C:", "Bob", "Data", "acllmdb", "aclImdb", "train", "pos")

acllmdb\aclImdb\train\pos

rxGetOption("sampleDataDir")