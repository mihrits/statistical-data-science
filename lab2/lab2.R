### "diagnose" male gender

## load the data
load(url("http://www.ms.ut.ee/mart/andmeteadus/students.RData"))


##attach the data (still not recommended though)
attach(students)


##Let's look at the heights of women and men
# Height of women
hist(height[gender==1])
# Height of men
hist(height[gender==2])

##What kind of graphs do you get? Which of them is most pleasant? 
##Do you understand what (or maybe guess) what 
#these extra arguments and parameters do?

##Option 1
hist(height[gender==1], density=40, breaks=20, prob=TRUE,
     xlab="Height (cm)", col="red2", ylab="density",
     main=" Distribution of height of men and women ", xlim=c(150, 210))
hist(height[gender==2], density=30, angle=135, breaks=20, prob=TRUE,
     add=TRUE, col="blue")
legend("topright", density=c(40, 30), fill=c("red2", "blue"),
       angle=c(45, 135), c("Women", "Men"))


##Option 2
hist(height[gender==1], breaks=20, prob=TRUE,
     xlab="Height (cm)", col=rgb(1,0,0, 0.5), ylab="", yaxt="n",
     main=" Distribution of height of men and women", xlim=c(150, 210))
hist(height[gender==2], breaks=20, prob=TRUE,
     add=TRUE, col=rgb(0,0,1,0.5))
legend("topright", fill=c(rgb(0,0,1,0.5), rgb(1,0,0, 0.5)),
       c("men", "women"))

##Option 3
par(mfrow=c(2,1))
hist(height[gender==1], breaks=20, prob=TRUE,
     xlab="Height (cm)", col=rgb(1,0,0, 0.5), ylab="", yaxt="n",
     main="Women", xlim=c(150, 210))
n_mean=mean(height[gender==1])
n_sd=sd(height[gender==1])
curve(dnorm(x, mean=n_mean, sd=n_sd), col="red3", lwd=2, add=TRUE)
hist(height[gender==2], breaks=20, prob=TRUE,
     col=rgb(0,0,1,0.5), yaxt="n", ylab="",
     main="Men", xlab="Height (cm)", xlim=c(150, 210))
m_mean=mean(height[gender==2])
m_sd=sd(height[gender==2])
curve(dnorm(x, mean=m_mean, sd=m_sd), col="navyblue", lwd=2,
      add=TRUE)
par(mfrow=c(1,1))

###Draw a graph that would enable comparing weight distributions of men and women!

hist(weight[gender==1], density=40, breaks=20, prob=TRUE,
     xlab="Weight (kg)", col="red2", ylab="density",
     main=" Distribution of weight of men and women ", xlim=c(40, 120))
hist(weight[gender==2], density=30, angle=135, breaks=20, prob=TRUE,
     add=TRUE, col="blue")
legend("topright", density=c(40, 30), fill=c("red2", "blue"),
       angle=c(45, 135), c("Women", "Men"))


par(mfrow=c(2,1))
hist(weight[gender==1], breaks=20, prob=TRUE,
     xlab="Weight (kg)", col=rgb(1,0,0, 0.5), ylab="", yaxt="n",
     main="Women", xlim=c(40, 120))
n_mean=mean(weight[gender==1], na.rm=T)
n_sd=sd(weight[gender==1], na.rm=T)
curve(dnorm(x, mean=n_mean, sd=n_sd), col="red3", lwd=2, add=TRUE)
hist(weight[gender==2], breaks=20, prob=TRUE,
     col=rgb(0,0,1,0.5), yaxt="n", ylab="",
     main="Men", xlab="Weight (kg)", xlim=c(40, 120))
m_mean=mean(weight[gender==2], na.rm=T)
m_sd=sd(weight[gender==2], na.rm=T)
curve(dnorm(x, mean=m_mean, sd=m_sd), col="navyblue", lwd=2,
      add=TRUE)
par(mfrow=c(1,1))




##Draw another nice graph that would enable to compare the weight distributions 
##of the groups formed by two variables on the same time: “gender” (male/female) 
##and “ambulance” (yes/no). Thus you should get the distributions of four groups 
##and make a graph that is divided to four subgraphs 
##(before plotting divide the plotting window to four subunits).

par(mfrow=c(2,2))
hist(weight[gender==1 & ambulance==1], breaks=20, prob=TRUE,
     xlab="Weight (kg)", col=rgb(1,0,0, 0.5), ylab="", yaxt="n",
     main=paste("Women that have used the ambulance ( n=",
                sum(gender==1 & ambulance==1, na.rm=T),")"),
     xlim=c(40, 120))
na_mean=mean(weight[gender==1 & ambulance==1], na.rm=T)
na_sd=sd(weight[gender==1 & ambulance==1], na.rm=T)
curve(dnorm(x, mean=na_mean, sd=na_sd), col="red3", lwd=2, add=TRUE)
hist(weight[gender==2 & ambulance==1], breaks=20, prob=TRUE,
     col=rgb(0,0,1,0.5), yaxt="n", ylab="",
     main=paste("Men that have used the ambulance ( n=",
                sum(gender==2 & ambulance==1, na.rm=T),")"), 
     xlab="Weight (kg)", xlim=c(40, 120))
ma_mean=mean(weight[gender==2 & ambulance==1], na.rm=T)
ma_sd=sd(weight[gender==2 & ambulance==1], na.rm=T)
curve(dnorm(x, mean=ma_mean, sd=ma_sd), col="navyblue", lwd=2, add=TRUE)
hist(weight[gender==1 & ambulance==0], breaks=20, prob=TRUE,
     xlab="Weight (kg)", col=rgb(1,0,0, 0.5), ylab="", yaxt="n",
     main=paste("Women that have not used the ambulance ( n=",
                sum(gender==1 & ambulance==0, na.rm=T),")"),
     xlim=c(40, 120))
nna_mean=mean(weight[gender==1 & ambulance==0], na.rm=T)
nna_sd=sd(weight[gender==1 & ambulance==0], na.rm=T)
curve(dnorm(x, mean=nna_mean, sd=nna_sd), col="red3", lwd=2, add=TRUE)
hist(weight[gender==2 & ambulance==0], breaks=20, prob=TRUE,
     col=rgb(0,0,1,0.5), yaxt="n", ylab="",
     main=paste("Men that have not used the ambulance ( n=",
                sum(gender==2 & ambulance==0, na.rm=T),")"),
     xlab="Weight (kg)", xlim=c(40, 120))
mna_mean=mean(weight[gender==2 & ambulance==0], na.rm=T)
mna_sd=sd(weight[gender==2 & ambulance==0], na.rm=T)
curve(dnorm(x, mean=mna_mean, sd=mna_sd), col="navyblue", lwd=2, add=TRUE)
par(mfrow=c(1,1))






## Let's check how good our 175cm threshold performs
table(height>175, gender)

#gender 1 - women
#gender 2 - men
#FALSE - person shorter than (or exactly) 175 cm and labeled as "woman"
#TRUE - person taller than 175 cm and labeled as "man"

# Let’s look at what proportion of men were correctly “diagnosed” as men 
# and what proportion of women were correctly “diagnosed” that they are not men:

prop.table(table(height>175, gender),2)

##give labels to the gender-variable
ActualGender=factor(gender, levels=1:2, labels=c("female", "male"))

##give labels to the test result
TestGender=factor(height>175, levels=c(TRUE, FALSE),
                  labels=c("M+", "M-"))

## Let's look at the variables we made
table(ActualGender)
table(TestGender)

##crosstab / contingency table
FreqTable = table(TestGender, ActualGender)
FreqTable


prop.table(FreqTable,2)

# Same table, but values have been rounded to 3rd decimal:
round(prop.table(FreqTable,2),3)


## Figure of the proportions
barplot(prop.table(FreqTable,2), legend=T)

## Make a figure to a new window with a fixed size
windows(width=6, height=4)# For MACs use quartz() command instead!
barplot(prop.table(FreqTable,2)*100, xlim=c(0,3), legend=T, ylab="%")


## What would be the measures of our test if we would 
## “diagnose” all students over 170cm as men?

round(prop.table(table(height>170, gender),2),2)

# Sensitivity = 96%
# Specificity = 67%





## Let's find PPV (positive predictive value) using Bayes formula
# (sensitivity*prevalence) / (sensitivity*prevalence + (1-specificity)*(1-prevalence))
round(prop.table(FreqTable,2),3)
prop.table(table(ActualGender))
0.818 * 0.224 / ( 0.818 * 0.224 + 0.0976 * ( 1-0.224 ) )


## PPV can be obtained as well like this:
round(prop.table(FreqTable,1),3)

###Find the PPV of our test for Faculty of Science and Technology students,
## where prevalence of men is 58%

