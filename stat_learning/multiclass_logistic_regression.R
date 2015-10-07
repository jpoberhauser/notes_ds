
#####
#Classification in R
#glm function in R
require(ISLR)
names(Smarket)
#we want to use Direction:Direction’ A factor with levels ‘Down’ and ‘Up’ indicating
# whether the market had a positive or negative return on a given day
#direction as a response using logistic regression:
pairs(Smarket, col-Smarket$Direction)

glm.fit<- glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,
  data=Smarket, family=binomial)
summary(glm.fit)
#None of the coefficients are significant here:
#Possibly these variables are ver correlated

#Now we can make predictions using tha fited model:
glm.probs <- predict(glm.fit, type = "response")
#prediciton on whether the market is going to be up or down given the#predictors

#turn it into a logical with a threshold of 0.5:
glm.preds <- ifelse(glm.probs>0.5,"Up","Down")

#Make atable to cpmpare true against predicted
attach(Smarket)
table(glm.preds,Direction)
#This table, in diagonal is where we are correct.
#We get the ,ean to see how we did, and it turns out, we did slightly better than chance:
mean(glm.pred==Direction)


#~~~~~~~~~~~~~
#We may want to divide into training and testing sets
#~~~~~~~~~~~~~
train = Year<2005
glm.fit<- glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,
  data=Smarket, family=binomial,subset=train)
glm.probs <- predict(glm.fit, newdata<-Smarket[!train,],type="response")
glm.pred<-ifelse(glm.probs > 0.5,"Up","Down")
Direction.2005 <- Smarket$Direction[!train]
table(glm.pred,Direction.2005)
mean(glm.pred==Direction.2005)