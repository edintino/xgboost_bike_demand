library(caret)
library(xgboost)
library(ggplot2)
library(caTools)

############################################## deals with the date

date_func <- function(dataset) {
  
  date <- as.Date(dataset$datetime)
  
  years <- as.integer(format(date,'%Y'))
  months <- as.integer(format(date,'%m'))
  days <- as.integer(format(date,'%d'))
  hours <- as.integer(substr(dataset$datetime,12,13))
  
  dataset <- dataset[,-1]
  dataset$year <- years
  dataset$month <- months
  dataset$day <- days
  dataset$hour <- hours
  
  return(dataset)
}

############################################## read in dataset

dataset <- read.csv('train.csv')
dataset <- date_func(dataset)
dataset <- dataset[-c(9,10)]


set.seed(123)
split = sample.split(dataset$count, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

############################################## parameter tuning with 5-fold CV for L1 and L2 regularization
params <- data.frame(alpha = rep(seq(0,0.2,0.1),each=7), lambda = rep(seq(0.9,1.5,0.1),3))

n_folds = 5
folds <- createFolds(training_set$count, k=n_folds)
errors <- rep(0,nrow(params))

for (i in seq_len(nrow(params))) {
  cv = sapply(folds, function (x) {
    param <- list(alpha = params[i,1], lambda = params[i,2])
    training_fold <- training_set[-x,]
    training_fold$count <- log(training_fold$count)
    test_fold <- training_set[x,]
    
    classifier <- xgboost(params = param, data = as.matrix(training_fold[-9]),
                          label = training_fold$count,
                          nrounds = 50)
    
    y_pred <- predict(classifier, newdata = as.matrix(test_fold[-9]))
    y_pred <- exp(y_pred)
    
    RMSLE <- sqrt(mean((log(y_pred+1) - log(test_fold$count+1))^2))
    return(RMSLE)  
  })
  accuracy = mean(cv)
  errors[i] <- accuracy
  print(i)
}

params.min <- params[which.min(errors),]

param <- list(alpha = params.min$alpha, lambda = params.min$lambda)

############################################## train the model

dataset$count <- log(dataset$count)

classifier <- xgboost(params = param,
                      data = as.matrix(dataset[-9]),
                      label = dataset$count,
                      nrounds = 50)

############################################## prediction with our model

testset <- read.csv('test.csv')
date <- testset$datetime

testset <- date_func(testset)

preds <- predict(classifier, newdata = as.matrix(testset))
preds <- exp(preds)
preds <- as.integer(round(preds))

solution <- paste(date,preds,sep=',')

write.table(list("datetime,count" = solution), "solution.csv",row.names = FALSE,quote = FALSE)
