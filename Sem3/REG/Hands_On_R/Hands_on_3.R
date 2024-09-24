df = read.csv(file="C:/Users/Hp/Desktop/DS Semester III/Predictive Analysis - Regression and Classification/Hands On/Lucknow_1990_2022.csv",header = T)

View(df)

sumry1 = summary(df)
n= nrow(df)

for(i in 2:n){
  if(is.na(df$tavg[i])==T) df$tavg[i] = df$tavg[i-1]
}

sumry2 = summary(df)

df$time = as.Date(df$time,format = "%d-%m-%Y")
str(df)

library(ggplot2)

ggplot(df,aes(x=time))+
  geom_line(aes(y=tmax))

df_sub = df[1:(3*365),]

ggplot(df_sub,aes(x=time))+
  geom_line(aes(y=tavg))

# tm <- time(df_sub)

## Objective is : we want to predict the temperature 
##                on 1st May 2035 


w =2*pi/365.25
df$tm = as.numeric(df$time)-as.numeric(df$time[5000])

# https://www.geeksforgeeks.org/step-function-in-r/

mod = lm(tavg ~tm + I(tm^2)+
           sin(w*tm)+cos(w*tm)+
           sin(2*w*tm)+cos(2*w*tm)+
           sin(3*w*tm)+cos(3*w*tm)+
           sin(4*w*tm)+cos(4*w*tm)+
           sin(5*w*tm)+cos(5*w*tm)+
           sin(6*w*tm)+cos(6*w*tm),data=df)

summary(mod)

mod = step(mod)
summary(mod)

fit_hat <- mod$fitted.values

plot(df$tm[1:(3*365)], df$tavg[1:(3*365)], type = 'l', xlab = "", ylab = 'tavg', col = 'grey')
lines(df$tm[1:(3*365)], fit_hat[1:(3*365)],  col = 'red')



plot(df$tm[1:(20*365)], df$tavg[1:(20*365)], type = 'l', xlab = "", ylab = 'tavg', col = 'grey')
lines(df$tm[1:(20*365)], fit_hat[1:(20*365)],  col = 'red')

df_new = data.frame(matrix(NA,nrow = (365*20),ncol=1))
colnames(df_new) = "time"

m  = (365*20)
df_new$time = df$time[n]+1:m

df_new$tm  = as.numeric(df_new$time)-as.numeric(df_new$time[5000])

# View(df_new)
tail(df)
tail(df_new)

plot(NULL,xlim=c(df$time[1],df_new$time[m]),ylim=c(15,35))
lines(df$time, df$tavg,  col = 'grey')
lines(df$time, mod$fitted.values,  col = 'red')
lines(df_new$time, predict(mod,newdata = df_new,lwd=2
),  col = 'purple')


mod$fitted.values

df_may_1_2022 = df[df$time==as.Date("2022-05-01",format= "%Y-%m-%d"),c("time","tm")]
df_may_1_2042 = df_new[df_new$time==as.Date("2042-05-01",format= "%Y-%m-%d"),]

df_may_1 = rbind.data.frame(df_may_1_2022,df_may_1_2042)

df_may_1$tavg_pred = predict(mod,newdata = df_may_1)

sumry = summary(mod)

sigma = sumry$sigma

df_may_1$P_tavg_gt_35 = pnorm(c(28,28),mean=df_may_1$tavg_pred,sd =sigma,lower.tail = F)

df_may_1$P_tavg_gt_35[2] / df_may_1$P_tavg_gt_35[1]


## Residual Analysis


df$resid = mod$residuals

ggplot(df[1:(3*365),], aes(x=time))+
  geom_line(aes(y=resid))

acf(df$resid,lag.max = 400)
# The plot suggests a strong auto-correlation
pacf(df$resid, lag.max = 400)

bartlett.test(mod)
adf.text(df$resid) ## check for stationary

shapiro.test(df$resid[1:4500])

library(forecast)

df$tavg_pred = mod$fitted.values
x_mat = as.matrix(df[,c("tavg_pred")])


mod_resid = auto.arima(df$resid,
                       max.p = 10,
                       max.q = 10,
                       max.P = 3,
                       max.Q = 3,
                       max.order = 20,
                       stationary = TRUE)

mod_resid

forcast1 = forecast(mod_resid, h=(365*20))
plot(forcast1)
# ARIMA is not very good for a long period of time. It can only be useful for few time steps into the future forecast.


