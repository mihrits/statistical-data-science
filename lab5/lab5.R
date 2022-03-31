# Statistical Data Science
# 5. lab session

# Linear regression -------

# Load the data
load(url("http://www.ms.ut.ee/mart/andmeteadus/students.RData"))
attach(students)

# Model on blood pressure and height
model1 = lm( SVR ~ height )
summary(model1) 

# Calculating estimates
predict(model1, data.frame(height=c(170, 180)))

# Mean confidence and prediction intervals 
predict(model1, data.frame(height=c(170, 180)), 
        interval="confidence")
predict(model1, data.frame(height=c(170, 180)), 
        interval="prediction")


# A simple plot of the model for yourself
plot(height, SVR)
abline(model1)


# Plot for a presentation (or for showing off)
windows(width=8, height=6)
# quartz(width=8, height=6) # for MAC users
# dev.new(width=8, height=6) # for Linux users

plot(height, SVR, pch=20, cex=1.5,
     col=c("pink","skyblue")[gender],    
     main="Height and blood pressure" )

xx=seq(140, 210, length=100)

temp=predict(model1, 
             data.frame(height=xx),
             interval="prediction")

lines(xx, temp[,1], lwd=3)
lines(xx, temp[,2], lty=2)
lines(xx, temp[,3], lty=2)

legend("topleft", 
       c("men", "women"), 
       col=c("skyblue", "pink"), 
       pch=20, pt.cex=2)


# Multidimenstional regression ----
model2 = lm (SVR ~ height + weight + factor(gender) )
summary(model2)


# Exercise 
# Estimate systolic blood pressure with weight

# -- Your code --


# Correlations ----
cor(data.frame(weight, height, SVR, DVR), 
    use="pairwise.complete.obs")

cor(data.frame(weight, height, SVR, DVR), use="complete.obs")

# Visualising correlations
install.packages("corrplot") # Run once
library("corrplot")

correlations=cor(data.frame(weight, height, SVR, DVR), 
                 use="pairwise.complete.obs")

corrplot(correlations)
corrplot(correlations, method="square")
corrplot(correlations, method="ellipse")
corrplot(correlations, method="number")
corrplot.mixed(correlations)

# Exercise
# Load the Google ratings data set
# Draw a graph describing the correlations between all the variables in the data set

# Load the data
load(url("http://www.ms.ut.ee/mart/andmeteadus/GOOGLEratings.RData"))  
attach(ratings)

# -- Your code ---


