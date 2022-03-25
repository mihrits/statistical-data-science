# Statistical Data Science
# 7. lab session


# Linear and multiple regression

# Load the data set (source: https://www.gapminder.org/)
load(url("http://www.ms.ut.ee/mart/andmeteadus/countries.RData")) 

# The data is from year 2008 and with the following variables
###########################################################
# country 	 country
# latitude 	 latitude of the middle point of the country (average)
# gdp 	     Gross domestic product per capita with PPP
# lifeW 		 average life expectancy at birth of women
# lifeM 		 average life expectancy at birth of men
# bmiW 		   average body mass index of women 
# bmiM 		   average body mass index of men
# alco	     consumption of alcohol (in litres a year per capita at least 15-years old)
# cars 		   vehicles per 1000 capita
# educW 		 mean years in school of women
# educM	 	   mean years in school of men
###########################################################


## Exercises 1 ----
# Order and interpret the correlations between variables. What do you see?   
(cor(countries[,-1]))

# For a clearer picture round the results:
round(cor(countries [,-1]),2)

# You can also use the corrplot package:
library(corrplot)
corrplot(cor(countries[,-1]))
corrplot.mixed(cor(countries[,-1]))


## Exercises 2 ----     
# Study the following scatter plot matrix:
pairs(countries[,-1], cex=0.5)

# What information can this provide besides the correlation analysis? (Are all relationships linear?)


## Exercises 3 ----  
# Study the relationship between number of vehicles and GDP:
hist(countries$gdp)

# Can one assume normal distribution now?
hist(log(countries$gdp))

# Extra exercise - Check the same thing for cars.

# your code
hist(countries$cars)
hist(log(countries$cars))


#Let’s check the relationship between the two variables:
with(countries, plot(gdp, cars))


# Transform only the x-scale to logarithmic scale on the plot:
with(countries, plot(gdp, cars, log="x"))

# Transform both plot scales to logarithmic:
with(countries, plot(gdp, cars, log="xy"))

# Make the plot nicer - country names are displayed:
with(countries, plot(gdp, cars, log="xy", pch="")) 
with(countries, text(gdp, cars, country))



## Exercises 4 ----
# Study the relationship with a regression analysis. 
summary(lm(cars ~ gdp, data = countries))

# Are the model assumptions satisfied?
model1 = lm(cars ~ gdp, data = countries)
plot(model1, which = 1)


# Use the logarithm of GDP (what does R-squared suggest):
countries$lgdp = log(countries$gdp)
model2 = lm(cars ~ lgdp, data = countries)
summary(model2) 


# Check the assumptions once more:
plot(model2, which = 1)

# Fit a model with logarithms of both variables:
model3 = lm(log(cars) ~ lgdp, data = countries)
summary(model3)
plot(model3, which=1)

# Interpretation?



## Exercises 5 ----
# Fit a non-linear model - e.g. use polynomials:
model4 = lm(log(cars)~ poly(lgdp,2), data=countries)
model5 = lm(log(cars)~ poly(lgdp,3), data=countries)

# Compare the models using the BIC:
BIC(model3)
BIC(model4)
BIC(model5)

# Check predictions of the best model graphically:
plot(countries$lgdp, log(countries$cars), pch = " ")
text(countries$lgdp, log(countries$cars), countries$country)
points(countries$lgdp, fitted(model4), col = 2, pch = 16)


# To see GDP and number of vehicles original values we have to draw the plot a bit differently: 
plot(countries$gdp, countries$cars, pch=" ", log = "xy")
text(countries$gdp, countries$cars, countries$country)
points(countries$gdp, exp(fitted(model4)), col = 2, pch = 16)

# NB! Our model was fitted using the logarithmic transformation, then we have to use exp() 
# transform the result back.


## Exercises 6 ----
# Study how well does the model predict number of vehicles in Estonia. First - the actual values:
countries["Estonia", "cars"]

# What does the model predict?
predict(model4)["Estonia"]

# transform it back to original values – take exponent:
exp(predict(model4)["Estonia"])

# Exercise: Did Estonia have more or less cars in 2008 than predicted?

# your analysis


# Find the prediction interval:
exp(predict(model4, interval="predict")["Estonia",])

#Did the actual value fit into the interval?



## Exercises 7 ----
# Check if and how does mean body mass index (BMI) depend on GDP per capita.
# a. Calculate the average BMI of men and women: (bmiM+bmiW)/2
countries$bmi = with(countries, (bmiM + bmiW) / 2)

# b. Look at the histogram of new BMI and GDP – are they nearly normally distributed variables? 
# your code


# c. Draw a scatter plot (with the text command you can add country names)
# your code


# d. Add the regression line to the plot
# your code


# e. Fit a simple regression model. Decide whether to use the logarithmic transformation on GDP or not.
# your code


# f. Should you use a lienar or non-linear model? If needed fit a non-linear model (i.e. polynomial model). 
# your code


# g. What is the prognosis of mean BMI in Estonia (with 95% CI) and how much does it differ from reality?
# your code


# h. What is the prognosis of mean BMI in your country (with 95% CI) and how much does it differ from reality?
# your code




## Exercises 8 ----
# Check if mean BMI is dependent on education level and country’s latitude (additionally to GDP)? 
# Calculate the mean education level of men-women  

# your code   


# Fit the multiple regression model using:
model = lm(bmi ~ poly(lgdp, 2) + educ + latitude, data = countries)
summary(model)

# Are all model variables statistically significant? 
# Leave the non-significant ones out and fit the model again.

# Fit a model with mean BMI of men-women and then fit a model where BMI is treated separately 
#  for men and women (models with bmiN ja bmiM. Leave the averaged men-women education as it is).



## Other exercises - not mandatory ----
# Fit a model with GDP, education and latitude influencing the difference of BMI between men and women.

# your code


# Is alcohol consumption dependent on latitude? What other variables should be considered for this model?

# your code



# Does life expectancy of men depend on alcohol consumption? What are your conclusions? 

# your code



# If inhabitants of Estonia were to consume 5 litres of alcohol less, how would life expectancy change? 
#  Would the results of this analysis give the right answer at all? 

# your code

