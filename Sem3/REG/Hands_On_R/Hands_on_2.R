## Modeling trend and seasonality in time-series data
rm(list = ls())
plot(AirPassengers, lwd = 2, col = 'purple')
tm <- time(AirPassengers)


n <- length(tm)



## Consider from 1949 - 1956, i.e., 8 years of data as training data

m<- (12*8)
data_train <- data.frame(cbind(y = AirPassengers[1:m], tm=tm[1:m]))


## Consider from 1957 - 1960, i.e., 4 years of data as testing data
data_test <- data.frame(cbind(y=AirPassengers[(m+1):n], tm=tm[(m+1):n]))


plot(NULL, xlim = c(tm[1], tm[n]), ylim = c(90, 650), ylab = "Air Passengers", xlab = '')
points(data_train$tm, data_train$y, type = 'l', lwd=2, col='purple')
points(data_test$tm, data_test$y, type = 'l', lwd = 2, col = 'blue')
abline(v=tm[m], col = 'red', lwd = 2, lty = 1)


fit_trend <- lm(y~tm+I(tm^2), data=data_train)
summary(fit_trend)

fit_hat <- fit_trend$fitted.values
fit_hat <- ts(fit_hat, frequency = 12, start = 1949)

lines(fit_hat, col = 'darkgreen', lwd = 2)

resid <- ts(fit_trend$residuals, frequency = 12, start = 1949)
plot(resid, lwd = 2, col = 'purple', pch = 20)
abline(h = 0, col = 'blue', lwd = 2)

w <- 2 * pi
data_train$resid <- fit_trend$residuals
fit_resid <- lm(resid ~ sin(w*tm) + cos(w*tm), data = data_train)
resid_hat <- fit_resid$fitted.values
resid_hat <- ts(resid_hat, frequency = 12, start = 1949)
lines(resid_hat, lty = 2, col = 'red')


fit_resid <- lm(resid ~ sin(w*tm) + cos(w*tm) + sin(2*w*tm) + cos(2*w*tm), data = data_train)
resid_hat <- fit_resid$fitted.values
plot(resid, lwd = 2, col = 'purple', pch = 20)
abline(h = 0, col = 'blue', lwd = 2)
resid_hat <- ts(resid_hat, frequency = 12, start = 1949)
lines(resid_hat, lty = 2, col = 'red')




fit_trend_season <- lm(y~tm + I(tm^2)
                       + sin(w*tm) + cos(w*tm)
                       +sin(2*w*tm) + cos(2*w*tm)
                       +sin(3*w*tm) + cos(3*w*tm)
                       , data = data_train)
summary(fit_trend_season)

plot(NULL, xlim = c(tm[1], tm[n]), ylim = c(90, 650), ylab = 'Air passengers', xlab = '')
points(data_train$tm, data_train$y, type = 'l', lwd = 2, col = 'purple')
abline(v = tm[m], col = 'red', lwd = 2, lty = 1)

fit_hat <- fit_trend_season$fitted.values
fit_hat <- ts(fit_hat, frequency = 12, start = 1949)
lines(fit_hat, lty = 1, lwd = 2, col = 'red')


pred <- predict(fit_trend_season, newdata = data_test)              
pred <- ts(pred, frequency = 12, start = tm[(m+1)])
lines(pred, lty = 1, lwd = 2, col = 'green')
points(data_test$tm, data_test$y, type = 'l', lwd = 2, col = 'blue')


fit_trend_season_transform <- lm(log(y) ~ tm + I(tm^2)
                                 +sin(w*tm)+cos(w*tm)
                                 +sin(2*w*tm)+cos(2*tm*tm)
                                 +sin(3*w*tm) + cos(3*w*tm)
                                 +sin(4*w&tm) + cos(4*w*tm)
                                 +sin(5*w*tm) + cos(5*w*tm)
                                 +sin(6*w*tm) + cos(6*w*tm)
                                 , data = data_train)
summary(fit_trend_season_transform)


fit_tred=nd_season_transform <- step(fit_trend_season_transform)

plot(NULL, xlim = c(tm[1], tm[n]), ylim = c(90, 650), ylab = 'Air passengers', xlab = '')
points(data_train$tm, data_train$y, type = 'l', lwd = 2, col = 'purple')
abline(v = tm[m], col = 'red', lwd = 2, lty = 1)

fit_hat <- exp(fit_trend_season_transform$fitted.values)
fit_hat <- ts(fit_hat, frequency = 12, start = 1949)
lines(fit_hat, lty = 1, lwd = 2, col = 'red')


pred <- exp(predict(fit_trend_season_transform
                    ,newdata = data_test))
pred <- ts(pred, frequency = 12, start = tm[(m+1)])
lines(pred, lty=1, lwd=3, col = 'green')
points(data_test$tm, data_test$y, type='l', lwd=2, col='blue')


## Auto Regressive Model
data <- data.frame(cbind(y=AirPassengers[1:n], tm=tm[1:n]))
data$y_lag1 <- NA
data$y_lag1[2:n]<-data$y[1:(n-1)]
head(data)
m <- (12*8)
data_train <- data[1:m,]
data_test <- data[(m+1):n,]

head(data_train)

plot(NULL, pch=20,col='purple',xlim=c(90,650),ylim=c(90,650)
     ,xlab=expression(y(t-1))
     ,ylab=expression(y(t)))
points(data_train[,c('y_lag1','y')],pch=20,col='purple',type='b')
points(data_test[,c('y_lag1','y')],pch=20,col='blue',type='b')

fit_ar1 <- lm(y~y_lag1, data = data_train)
summary(fit_ar1)

plot(fit_ar1$fitted.values, fit_ar1$residuals, pch = 20)
plot(ts(fit_ar1$residuals),lwd=2)


plot(NULL,xlim = c(tm[1],tm[n]),ylim=c(90, 650),ylab = 'Air Passengers', xlab='')
points(data_train$tm, data_train$y, type='l',lwd=2,col='purple')
abline(v=tm[m],col='red',lwd=2,lty=1)

fit_hat <- fit_ar1$fitted.values
fit_hat <- ts(fit_hat, frequency = 12, start = 1949)
lines(fit_hat, lty=1,lwd=2,col = 'red')

pred <- predict(fit_ar1
                ,newdata = data_test)
pred <- ts(pred, frequency = 12, start = tm[(m+1)])
lines(pred,lty=1,lwd=3,col='green')
points(data_test$tm, data_test$y, type='l',lwd=2,col='blue')


### Granger Causality Test
