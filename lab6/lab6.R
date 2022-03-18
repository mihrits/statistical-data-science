# Statistical Data Science
# 6. lab session

# Load data

# Load the data
load(url("http://www.ms.ut.ee/mart/andmeteadus/students.RData"))
attach(students)

# Sample size and power of a test -----

# standard deviation of height
sd(students$height)

# the power of t-test
power.t.test(n=100, delta=1, sd=8.4)


# standard deviation of height for men and women
sd_male = sd(students$height[students$gender==2])
sd_female = sd(students$height[students$gender==1])

# Exercise
# Power of test if we were to survey 100 porridge-eating and 100 not-porridge-eating men

# < your code >
power.t.test(n=100, delta=1, sd=sd_male)

# Power of test if we were to survey 100 porridge-eating and 100 not-porridge-eating women

# < your code >
power.t.test(n=100, delta=1, sd=sd_female)


# Power of a test can be ordered for multiple sample sizes in one command:
power.t.test(n=c(100, 200, 1000), delta=1, sd=8.4)

# powers can be extracted 
power.t.test(n=c(100, 200, 1000), delta=1, sd=8.4)$power


# Plotting power of test results ----

# Power test results on plots 
n=2:3000
power=power.t.test(n=n, delta=1, sd=8.4)$power

windows(width=8, height=6)
plot(n, power, type="l", xlab="Group size", 
     ylab="Power", ylim=c(0,1), lwd=3)

abline(h=seq(0,1, 0.2), lty=3)
abline(v=seq(0,3000, 500), lty=3)
text(1000, 0.7, "1cm")

power2=power.t.test(n=n, delta=2, sd=8.4)$power
lines(n, power2, col="blue3", lwd=3)
text(500, 0.9, "2cm", col="blue3")



# If the actual difference of means is 1cm, then the sample size needed to achieves power 80%:
power.t.test(power=0.8, delta=1, sd=8.4)

# Plot sample sizes for decision making
delta=seq(0, 10, length=100)
power=power.t.test(n=100, delta=delta, sd=8.4)$power

plot(delta, power, type="l", 
     main="Sample size 100+100")


# Exercise ----

# How many pictures do we need from women if we wish to show 
# with 80% power that women underestimate other women’s weights?

# < your code >
power.t.test(power=0.8, delta=2.3, sd=10)




# Simulations ----

# Can we discover the negative effects of the gene mutation in a study with 1000 subjects?

# Total number of simulations:
simulations=50000

# We need a place to store p-values calculated on each simulation run:
pvalues=rep(NA, simulations)

# Samle size (how many individuals are studied):
sample_size=1000

# Repeat random sampling multiple times: 
for (i in 1:simulations){
  
  # Let’s generate an indicator for each sampled individual
  # that shows if they have the studied mutation (1) or not (0). 
  # Prevalence of the mutation is 0.1:
  mutation = rbinom(sample_size, 1, p=0.1)
  
  # Generate a variable that shows if the person has the disease (1) or not (0).
  # notice that the prevalence of the disease changes according to the value of 
  # mutation variable:
  disease = rbinom(sample_size, 1, p=0.05+0.05*mutation)
  
  # What happens if there happen to be no persons with the disease or mutation?
  # Just in case we will let R know what values would we expect to see for both 
  # variables. Then room will be made in the frequency table for all expected 
  # values – even in the case where there are no individuals with the disease 
  # or mutation in  the sample, frequency table will show 0. 
  mutation=factor(mutation, levels=0:1)
  disease = factor(disease, levels= c(1,0) )
  
  # Compare the prevalence of the disease among individuals with the gene mutation 
  # and without the mutation using prop.test command. Save the p-value:
  pvalues[i]=prop.test( table(mutation, disease) )$p.value
  
}  # This ends the cycle – commands after this bracket will not be repeated 5000 times 

# Assess the probability of small p-value, in other words find the power of the test: 
mean(pvalues<0.05) 

