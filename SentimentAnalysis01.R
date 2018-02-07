## getSentiment(vars, ...) - Scores natural language text and creates a column that contains probabilities that the sentiments in the text are positive.

# Create the data
CustomerReviews <- data.frame(Review = c(
  "I really did not like the taste of it",
  "It was surprisingly quite good!",
  "I will never ever ever go to that place again!!"),
  stringsAsFactors = FALSE)

# Get the sentiment scores
sentimentScores <- rxFeaturize(data = CustomerReviews, overwrite=TRUE,
                               mlTransforms = getSentiment(vars = list(SentimentScore = "Review")))

# 1           I really did not like the taste of it      0.4617899
# 2                 It was surprisingly quite good!      0.9601924
# 3 I will never ever ever go to that place again!!      0.3103435

# Let's translate the score to something more meaningful
sentimentScores$PredictedRating <- ifelse(sentimentScores$SentimentScore > 0.6, 
                                          "AWESOMENESS", "BLAH")

# Let's look at the results
sentimentScores

###########################################################################################

library(readr)

#download data
download.file("http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz", destfile = "aclImdb_v1.tar.gz")
untar("aclImdb_v1.tar.gz") #this can take a few minutes

#prepare data
set.seed(1)
fnames=list.files("aclImdb", pattern = "[[:digit:]_]+.txt", recursive = TRUE, full.names = TRUE)
fnames=grep(pattern = 'unsup', fnames, invert = TRUE, value = TRUE)
fnames=fnames[sample(length(fnames))]

getIntSentiment <- function(fname) {
  tname=unlist(strsplit(fname, "[.]"))[1]
  as.integer(unlist(strsplit(tname, "_"))[2])
}

df=data.frame(fname=fnames, review = sapply(fnames, read_file),
              sentiment= sapply(fnames, getIntSentiment)>5, stringsAsFactors = FALSE)

#train, validation, test split
trainxdf=RxXdfData('train.xdf')
validationxdf=RxXdfData('validation.xdf')
testxdf=RxXdfData('test.xdf')
trainInd=grep(pattern="train", fnames, value=FALSE)
validationInd=c(1:50000)[-trainInd][1:12500]
testInd=c(1:50000)[-trainInd][-(1:12500)]

#save sentiment from the pre-trained model as a feature
rxFeaturize(data=df[trainInd,], outData = trainxdf,
            mlTransforms = list(getSentiment(vars = c(preSentiment="review"))),
            overwrite = TRUE, randomSeed = 1)
rxFeaturize(data=df[validationInd,], outData = validationxdf,
            mlTransforms = list(getSentiment(vars = c(preSentiment="review"))),
            overwrite = TRUE, randomSeed = 1)
rxFeaturize(data=df[testInd,], outData = testxdf,
            mlTransforms = list(getSentiment(vars = c(preSentiment="review"))),
            overwrite = TRUE, randomSeed = 1)
#rm(df)

#train models
form1=sentiment~reviewTran
form2=sentiment~reviewTran+preSentiment
ft=list(featurizeText(vars=c(reviewTran="review"), language = "English",
                      stopwordsRemover = stopwordsDefault(),
                      case = "lower", keepDiacritics = FALSE, keepPunctuations = FALSE,
                      keepNumbers = TRUE, dictionary = NULL,
                      wordFeatureExtractor = ngramCount(), charFeatureExtractor = NULL,
                      vectorNormalizer = "l2"))
rm(list=ls(pattern = 'model\\.')) #make sure no other variable names match pattern = 'modelr\\.'
model.rxlr1=rxLogisticRegression(form1, trainxdf, type='binary', mlTransforms = ft)
model.rxlr2=rxLogisticRegression(form2, trainxdf, type='binary', mlTransforms = ft)
model.rxff1=rxFastForest(form1, trainxdf, type = 'binary', mlTransforms = ft, randomSeed = 1)
model.rxff2=rxFastForest(form2, trainxdf, type = 'binary', mlTransforms = ft, randomSeed = 1)

#performance on validation set
scores = rxImport(validationxdf, overwrite = TRUE)
for (modelname in ls(pattern = 'model\\.')) {
  model=get(modelname)
  scores = rxPredict(model, scores, extraVarsToWrite =  names(scores), overwrite = TRUE,
                     suffix = paste(' ', model$Description, model$params$Formula, sep='.'))
}
rxRocCurve("sentiment", grep("Probability", names(scores), value=TRUE), scores)

#performance on test set
scores = rxImport(testxdf, overwrite = TRUE)
for (modelname in ls(pattern = 'model\\.')) {
  model=get(modelname)
  scores = rxPredict(model, scores, extraVarsToWrite =  names(scores), overwrite = TRUE,
                     suffix = paste(' ', model$Description, model$params$Formula, sep='.'))
}
rxRocCurve("sentiment", grep("Probability", names(scores), value=TRUE), scores)