# Statistical Data Science
# 9. lab session

# Logistic regression -------

# Load the data
load(url("http://www.ms.ut.ee/mart/andmeteadus/students.RData"))
students[1:3,]

# Recode gender
students$gender2=1*(students$gender==2)

# Check if recoding is correct with a 2-dimensional table of frequencies
attach(students)
table(gender, gender2)

# Interpretation
# Choosing a random student from the medical faculty we have 148/512 odds of meeting a male student:
148/512

# Fit a simple logistic regression model
model0=glm(gender2~1, family=binomial())
summary(model0)


# The model estimates the odds of picking a man among medical faculty students:
exp(-1.24111)

# A more precise method:
odds=exp(coef(model0))
odds

# Convert odds to probability:
p=odds/(1+odds)
p

# Compare with mean of gender2 and proportion of men:
mean(gender2)
prop.table(table(gender2))

# ... or use the predict() command:
predict(model0, data.frame(rndm=1), type="resp")



# --------------
# Let's fit a more complex model
model1=glm(gender2~factor(beer), family=binomial())
summary(model1)

# The odds of a non-beer-drinking student being a man:
exp(-2.2659)

# ...convert to probability
exp(-2.2659)/(1+exp(-2.2659))


# Odds of being a man when consuming 13 and more bottles of beer  
odds=exp(-2.2659+4.0577)
odds

# ... convert into probability
p=odds/(1+odds)
p

# ... or using the predict() command
predict(model1, data.frame(beer="13..."), type="resp")

# Probability of begin a man if you drink 0..1 bottles of beer a week (notice the space before 0!):
predict(model1, data.frame(beer=" 0..1"), type="resp")

# Compare the results with gender2 averages or male student proportions:
by(gender2, beer, mean)
prop.table(table(gender2[beer==" 0"]))
prop.table(table(gender2[beer==" 0..1"]))
prop.table(table(gender2[beer=="13..."]))


# Add more complexity - add height to the model
model2=glm(gender2~factor(beer)+height, family=binomial())
summary(model2)

# And eve more - add the square of height
model3=glm(gender2~factor(beer)+height+I(height^2), family=binomial())
summary(model3)

# Compare models - which one should be used?
anova(model2, model3, test="Chisq")

# depict model2 output graphically
xx=seq(150,210, length=1000)
y1=predict(model2, data.frame(height=xx, beer="13..."), type="resp")
y2=predict(model2, data.frame(height=xx, beer=" 0"), type="resp")

plot(xx, y1, type="l", col="slateblue", lwd=2, xlab="height", 
     ylab="Probability of being male ")
lines(xx, y2, col="skyblue", lwd=2)

legend("topleft", c("13...", " 0"), lwd=2, 
       col=c("slateblue", "skyblue"), title="Beer consumption")

# Can you interpret the graphs?

# Drawing the ROC curve
install.packages("Epi")
library('Epi')

# Draw the ROC-curve:
ROC(form=gender2~factor(beer)+height)

# Let's double check the ROC curve results
# find the probability of being a man for all students using our model:
p=predict(model2, students, type="resp")
boxplot(p~gender2, ylab="Probability of being male (model2)")

# If probability of being a man is greater than 0.155, then we “prognose”  student to be a man:
prognosis=1*(p>0.155)

# Compare the prognosis to actual values:
table(prognosis, gender2)
prop.table(table(prognosis, gender2), margin = 2)

# Sensitivity
137/(137+11)

# Specificity 
443/(443+69)


# Exercise 1 -----
# Prognose your gender using the model (and the threshold 0.155). Did the computer get it right?

predict(model2, data.frame(height=183, beer=" 0"), type="resp")

# Exercise 2 -----
# What would be the specificity and sensitivity if we were to prognose gender using 0.5 as the threshold? 



# Let’s play out a hypothetical situation. Pick 100 men and 100 women from our data set and form a data set sample2:  
set.seed(1)
nr1 = 1:length(gender2)
nr2 = c(sample(nr1[gender2==0], 100), sample(nr1[gender2==1], 100))
sample2=students[nr2, ]
table(sample2$gender2)

# Fit a logistic regression model using the new data set:
model4=glm(gender2~height+beer, family=binomial(), data=sample2)

# Estimate gender of a 177cm tall non-beer-drinking student using model4  and model2:
predict(model4, data.frame(height=177, beer=" 0"), type="resp")
predict(model2, data.frame(height=177, beer=" 0"), type="resp")

# What's wrong?

# Try out with a simpler model:
model0=glm(gender2~1, family=binomial(), data=students)
model0a=glm(gender2~1, family=binomial(), data=sample2)

predict(model0,  data.frame(ab=1), type="resp")
predict(model0a, data.frame(ab=1), type="resp")

# What could be wrong?
