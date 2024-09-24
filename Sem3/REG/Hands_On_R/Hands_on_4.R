rm(list=ls())

German_Credit_Data <- read.csv(
  file = "C:/Users/Hp/Desktop/DS Semester III/Predictive Analysis - Regression and Classification/Hands On/German_Credit_Data.csv"
)

set.seed(321)
library(class)
library(MASS)
library(rpart)
library(randomForest)
library(e1071)
library(neuralnet)

data<- German_Credit_Data
data$Good_Bad <- data$Good_Bad - 1

## 1 = Bad ; 0 = Good

## Convert the dependent var to factor

data$Good_Bad <- factor(as.character(data$Good_Bad))

## Normalize the numeric variables

num.vars <- sapply(data, is.numeric)
data[num.vars] <- lapply(data[num.vars], scale)

train_proportion <- 0.7
n <- nrow(German_Credit_Data)
m <- ceiling(n*train_proportion)

set.seed(20240912)
train_id <- sample(1:n, m, replace = FALSE)

y_train <- data$Good_Bad[train_id]
y_test <- data$Good_Bad[-train_id]

### Naive Model

summary(y_train)
sum(y_train==0)/length(y_train)

### make all test cases as 0
naive.pred <- rep(0, length(y_test))
sum(y_test == naive.pred)/length(y_test)


### Confusion Table
conf_tabl <- table(naive.pred, y_test)
conf_tabl[1, 2]*6



### Fit KNN

## Selecting only 3 numeric variables for this demonstration. just to keep things simple

myvars <- c("Duration_in_month", "Credit_amount", "Installment_rate")
data.subset <- data[myvars]

summary(data.subset)

train_data <- data.subset[train_id,]
test_data <- data.subset[-train_id,]


# Need Class package for KNN
knn.1 <- knn(train_data, test_data, y_train, k = 1)
knn.5 <- knn(train_data, test_data, y_train, k = 5)
knn.20 <- knn(train_data, test_data, y_train, k = 20)

### Let's calculate the proportion of correct classification for k = 1, 5 and 20

100*sum(y_test == knn.1)/length(y_test) # For knn = 1
100*sum(y_test == knn.5)/length(y_test) # For knn = 5
100*sum(y_test == knn.20)/length(y_test) # For knn = 20


# Confusion table
conf_tabl <- table(knn.1, y_test)
conf_tabl[1, 2]*6 + conf_tabl[1, 2]

conf_tabl <- table(knn.5, y_test)
conf_tabl[1, 2]*6 + conf_tabl[1, 2]

conf_tabl <- table(knn.20, y_test)
conf_tabl[1, 2]*6 + conf_tabl[1, 2]


## Logistic Regression

data<- German_Credit_Data
data$Good_Bad <- data$Good_Bad - 1
train_proportion <- 0.7
n <- nrow(German_Credit_Data)
m <- ceiling(n*train_proportion)

set.seed(20240912)
train_id <- sample(1:n, m, replace = FALSE)

train_data <- data[train_id,]
test_data <- data[-train_id,]

logistic.reg.model <- glm(Good_Bad~.
                          ,family = binomial(link = 'logit')
                          ,data = train_data)

summary(logistic.reg.model)
logistic.reg.pred <- predict(logistic.reg.model, newdata = test_data, type = 'response')

hist(logistic.reg.pred)

logistic.reg.pred[logistic.reg.pred<0.5] <- 0
logistic.reg.pred[logistic.reg.pred>=0.5] <- 1

100*sum(y_test == logistic.reg.pred)/length(y_test)
conf_tabl <- table(logistic.reg.pred, y_test)
conf_tabl[1, 2]*6 + conf_tabl[1, 2]

