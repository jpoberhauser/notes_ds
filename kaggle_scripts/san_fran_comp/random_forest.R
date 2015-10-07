library(dplyr)
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}


# clear environment workspace
rm(list=ls())
# load data
train <- read.csv("data/train.csv")
test <- read.csv("data/test.csv")

dummy <- model.matrix( ~ dayofweek - 1, data = train)
#~~~~~~~~~~~~~~~~~
#Feature extraction and Enfgineering:
#~~~~~~~~~~~~~~~~~
names(train)<-tolower(names(train))
train$date_without_time <- as.Date(train$dates)
train$time <- substrRight(as.character(train$dates), 8)

train2 <- train[,-1]
# train2 <- train %>% select(-target)

# install randomForest package
install.packages('randomForest')
library(randomForest)
# set a unique seed number so you get the same results everytime you run the below model,
# the number does not matter
set.seed(12)
# create a random forest model using the target field as the response and all 93 features as inputs
fit <- randomForest(as.factor(target) ~ ., data=train2, importance=TRUE, ntree=100)
fit <- randomForest(category ~ ., data=train2, importance=TRUE, ntree=100)
 
# create a dotchart of variable/feature importance as measured by a Random Forest
varImpPlot(fit)
 
# use the random forest model to create a prediction
pred <- predict(fit,test,type="prob")
submit <- data.frame(id = test$id, pred)
write.csv(submit, file = "firstsubmit.csv", row.names = FALSE)