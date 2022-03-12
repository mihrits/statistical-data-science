# Statistical Data Science
# 4. lab session

# Hypothesis testing -------

## Hypothesis on population means -------

# Load the data
load(url("http://www.ms.ut.ee/mart/andmeteadus/students.RData"))
attach(students)

# Simple one sample hypothesis testing of mean
t.test( height[gender==2] , mu=173.83)
t_stat = (mean(height[gender==2])-173.83)/sd(height[gender==2])*sqrt(length((height[gender==2])))

# Exercise 1 -----
# Answer the following questions:
## A. Can male students’ mean weight be 75kg?


## B. Can male students’ mean weight be 76kg?


## C. Are the results contradictive? Why?


# Exercise 2 -----

# Is it possible that John has a fair die?
die_result = c()


# Additionally, to p-value you should also think 
# of other aspects of the exercise. What can they be?



## Hypothesis on probabilities ----

# Chi-square test
chisq.test(c(585, 1191, 590), p=c(0.25, 0.5, 0.25))

# Exercise 3
data=read.csv(url("http://www.ms.ut.ee/mart/andmeteadus/quake.csv"),
              header=TRUE)


data$date=as.Date(data$time)
data$weekday=weekdays(data$date)
data[1:3,]
table(data$weekday)

# If you not used to Estonian yet, then you might want to 
# find weekdays using the following command
data$weekday=factor(c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
)[as.POSIXlt(data$date)$wday + 1], 
levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# If you want the weekdays to appear in order (in frequency tables or plots)
data$weekday=factor(data$weekday,
                    levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
)

# Chi-square test
# Frequency table of earthquakes by weekdays
freqs = table(data$weekday)
freqs

# Probabilities under null-hypothesis - 
# we would expect to see the same number of earth quakes on every day,
# therefore probability of an earth quake on a single day would be 1/7
# and to vectorise it we can usethe rep() command
expected_prob = #your code
  expected_prob


# Now the chi-square test
chisq.test(freqs, p=expected_prob) 


# Testing two populations ----

## Comparing means----

# Mean weights of students who have had hospitalisation in the past 
# (medical_care=1) and the ones who have not (medical_care=0)
t.test(weight[medical_care==1], weight[medical_care==0])

# Exercise 4 ----
# your code

# Comparing probabilities ----
table(ambulance, health=="very good")
prop.test(c(52, 13), c(52+355, 13+60))


# Chi-square test for comparing study variable distribution
prop.table(table(gender, beer),1)*100
chisq.test(table(gender, beer))

# Expected frequencies
chisq.test(table(gender, beer))$expected

# Classify all students who drink more than 5 bottles a week 
# into a single (“drunkards”) group
beer4=factor(beer, labels=c("0", "0..1", "1..4", "5..", "5.."))
table(gender, beer4)
chisq.test(table(gender, beer4))
plot(table(beer4, gender), col=c("pink", "skyblue"))

# more formatted plot
students$genderF=factor(gender, levels=1:2,
                        labels=c("female", "male"))
windows(width=6, height=4)
barplot(prop.table(table(genderF, beer),2)*100,
        col=c("pink", "skyblue"), ylab="%", legend=T,
        xlim=c(0,8), xlab="Bottles drunk in a week",
        main="Relation between gender and beer consumption")


# Exercise 5
# your code

