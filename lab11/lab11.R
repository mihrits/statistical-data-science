# Statistical data science
# 11th lab session

# Cluster analysis

# In data set `world` there is data on 122 world countries 
# (combination of two data sets that we have seen in previous lab sessions). 
load(url("http://www.ms.ut.ee/mart/andmeteadus/world.RData"))
head(world)

# gdp               &     gross domestic product                    
# lifeF             &     average life expectancy at birth of women 
# lifeM             &     average life expectancy at birth of men   
# bmiF              &     average body mass index of women          
# bmiM              &     average body mass index of men            
# alco              &     consumption of alcohol (in litres a year per capita at least 15-years old) 
# cars              &     vehicles per 1000 capita                  
# educM             &     mean years in school of men               
# educF             &     mean years in school of women             
# CO2               &     CO2-emissioon (per capita)                
# CO2               &     CO2 emissions (metric tons per capita)    
# HealthExp_perc    &     Current health expenditure ( of GDP)      
# HealthExp_dollars &     Current health expenditure per capita (current USD)   
# Diab_prevalence   &     Diabetes prevalence ( of population ages 20 to 79)   
# Electricity_use   &     Electric power consumption (kWh per capita)           
# Cellphone_subscr  &     Mobile cellular subscriptions (per 100 people)        
# Urb_pop_perc      &     Urban population ( of total)             


## Non-hierarchical clustering - k-means method ----

# Before clustering we should remove missing values and scale the data. 
# Also transform the variables (e.g. logarithmic transformation) that seem to need it.
world_full = na.omit(world)
world_full$lgdp = log(world_full$gdp)
world_full$gdp = NULL # remove the original
scaled_world = scale(world_full)

# Look at scaled and unscaled data set, specifically values for Estonia - 
# which values exceed the mean, which are lower than the mean?
world_full["Estonia",]
scaled_world["Estonia",]

# Cluster countries into 3 groups
set.seed(12345)
cluster3 = kmeans(scaled_world, 3)
cluster3
cluster3$centers

# What would be the optimal number of groups. 
# One option is to look at *Sum of Squares Withint (SSW)* which 
# The following code will draw an "elbow plot":
k = 1:20
pr = 1
for (i in 2:20){
  km = kmeans(scaled_world,i)
  pr[i] = km$tot.withinss/km$totss
}

plot(k,pr,type="b")


# It seems that changes are big if the number of clusters is at most 6. 
k6 = kmeans(scaled_world, 6)

# What distinguishes the clusters. Use the familiar `corrplot` function 
library(corrplot)
corrplot(k6$centers, is.corr = F)

# We can also look at what countries belong to one or the other cluster:
rownames(scaled_world)[k6$cluster==1]
rownames(scaled_world)[k6$cluster==2]
rownames(scaled_world)[k6$cluster==3]
rownames(scaled_world)[k6$cluster==4]
rownames(scaled_world)[k6$cluster==5]
rownames(scaled_world)[k6$cluster==6]


# Into which cluster does Estonia belong to? 
# And what separates that cluster from the rest 
pc = summary(prcomp(scaled_world))$x
plot(pc[,1],pc[,2])
plot(pc[,1],pc[,2],type="n")
text(pc[,1],pc[,2],rownames(scaled_world))
text(pc[,1],pc[,2],rownames(scaled_world),col=k6$cluster)


## Hierarchical clustering

# In hierarcichal clustering we recive a so called tree. 
# Clustering is done based on a distance matrix, that we have to create at first. 
distances = dist(scaled_world)
hierarc_clusters = hclust(distances)
plot(hierarc_clusters)

# To separate the clusters we can highlight them witht the `cutree` function. 
rect.hclust(hierarc_clusters,3)

# Let's also try the 6 cluster solution:
plot(hierarc_clusters)
rect.hclust(hierarc_clusters,6)


# To compare current and previous results run the following commands:
hk6=cutree(hierarc_clusters,6)
table(k6$cluster,hk6)


# Other number of clusters are also an option. Where does Estonia land if we 
# have 20 clusters, what other countries are grouped together?
hk= cutree(hierarc_clusters,1:20)
hk["Estonia",]
hk[hk[,20]==7,]

# Notice, that the result very much depends on variables being used.

## If there is time: discriminant analysis

# Study the function `lda` and go through the example in the end 
# with the `iris` data set.
library(MASS)
?lda
