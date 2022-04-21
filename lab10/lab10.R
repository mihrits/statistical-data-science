# Statistical Data Science
# 10. lab session

# Principal component analysis -------

# PART I: The joy of discovery

# Load data
print(load(url("http://www.ms.ut.ee/mart/andmeteadus/WB.RData")))
WorldB[1:3,]

# Conduct PCA using the numeric variables (exclude the first variable, i.e. county’s name, 
# and only use those countries for which we know full information):

pca=prcomp( na.omit(WorldB[,-1]) , scale=T)
summary(pca)

# Find the values for the first principal component 
predict(pca, WorldB)[1:3,]

# Pick out the first two principal components and add to our data set:
WorldB=data.frame(WorldB, predict(pca, WorldB)[,1:2])
WorldB[1:2,]
attach(WorldB)

# Visualise the PCA resulls
plot(PC1, PC2, col="white")
text(PC1, PC2, Name)
text(PC1[Name=="Estonia"], PC2[Name=="Estonia"], 
     "Estonia", col="red" )

# Factor loading of the first two principal components
pca$rotation[,1:2]


# Ways of visualising principal component analysis results using factoextra package
install.packages("factoextra")
library(factoextra)

# Plot that describes the importance of principal components
fviz_eig(pca)

# Plot 2:
rownames(WorldB)=WorldB$Name
pca=prcomp( na.omit(WorldB[,2:13]) , scale=T)

fviz_pca_ind(pca,
             col.ind = "coord", # colour according to distance from 
             # center 
             repel = TRUE     # Don’t stack country names on each other 
)

# Plot 3 – loadings of observed variables into principal components
fviz_pca_var(pca,
             # colours according to loadings of first 3 components 
             col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             
             # Avoid stacking of text
             repel = TRUE     
)


# PART II: Using principal components

# Load data on diseases and desire for authoritarianism 
print(load(url("http://www.ms.ut.ee/mart/andmeteadus/Murray.RData")))
Murray[1:3,]

model=lm(authoritarianism~pathogens, data=Murray)
summary(model)

plot(Murray$pathogens, Murray$authoritarianism)
abline(model)

# Merge the Wordl Bank and Murray data sets
merged=merge(WorldB, Murray, by.x="Name", by.y="country", all.x=TRUE)
merged[1:3,]

# Fit a model including the first principal compnent
model2=lm(authoritarianism~pathogens+PC1, data= merged)
summary(model2)


