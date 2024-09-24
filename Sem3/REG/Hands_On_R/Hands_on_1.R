attach(mtcars)

plot(disp, mpg)

## mpg = b0 + b1 disp + e

modl = lm(mpg ~ disp, data = mtcars)

# This is supposed to be OLS
# We will also do this by scratch

## OLS : beta_hat = (X'X)^{-1}X'y

n = nrow(mtcars)
p = 2

X = matrix(NA, nrow = n, ncol = p)

colnames(X) = c("Intercept", "disp")

X[,"Intercept"] = 1

X[, "disp"] = mtcars$disp

y = mtcars$mpg

solve(t(X)%*%X) # Inverse of X'X

t(X)%*%y

beta_hat = solve(t(X)%*%X) %*% t(X)%*%y

# Check that both the solutions are exactly matching



summary(modl)



# Now we can calculate sigma^2 = RSS/(n-p)
# where RSS = (y-X beta_hat)' (y-X beta_hat)

RSS = t(y - X%*%beta_hat) %*% (y-X%*%beta_hat)
s_sqr = RSS/(n-p)
s = sqrt(s_sqr)  #  residual standard error

summary(modl)


Sx = solve(t(X)%*%X)
diag(Sx)   # diagonal of Sx
std.error = s[1,1] * sqrt(diag(Sx))

summary(modl)



# Now we will calculate the t-value

t_obs = beta_hat/std.error

summary(modl)



# Now we will calculate the p-value
# p = 2 * P(t>|t_observed| | H_0)

# Here we will use t-distribution, with n-p degrees of freedom
# This case, we only have to see the upper tail

p_value = 2 * pt(abs(t_obs), df = n-p, lower.tail = FALSE)
summary(modl)

# Note that in this case, we can generate the exact p-value, which is not given even in summary


e = y- X%*% beta_hat
summary(e)
summary(modl)


# The F-statistic is useful when we have 2 or more variables

modl2 = lm(mpg ~ disp + hp + wt, data = mtcars)
summary(modl2)





# H_0 : beta_1 = beta_2 = beta_3 = 0
# H_1 : At least one of them is non-zero

# On this we would do the F-test
# If F-test rejects, then we find out which variable is useful

# Now it is not used in practice


cor(mtcars[,c("disp", "hp", "wt")])

plot(disp ~ mpg, data = mtcars)
plot(hp ~ mpg, data = mtcars)
plot(hp ~ disp, data = mtcars)






n = nrow(mtcars)
p = 4
X = matrix(NA, nrow = n, ncol = p)
colnames(X) = c("Intercept", "disp", "hp", "wt")
X[,"Intercept"] = 1
X[,"disp"] = mtcars$disp
X[,"hp"] = mtcars$hp
X[,"wt"] = mtcars$wt