
###############################################################
# Data loading
###############################################################

library(ggplot2)
library(stringr)
library(readxl)
library(data.table)
library(openxlsx)
library(knitr)
library(kableExtra)
library(RColorBrewer)
library(scales)
library(dplyr)
library(gridExtra)
library(plotly)
library(car)

cd = getwd()
parent_dir <- dirname(cd)
file_path_data = file.path(parent_dir, "data")

data = read.table(file.path(file_path_data, "heart_data.csv"), header = T, sep = ",")

###############################################################
# Initial modifications
###############################################################

data$BMI = round(data$weight / (data$height / 100)**2, 2) #add BMI as variable

data$age = round(data$age / 365, 2) #age is initially given in days, lets put in years

data = data[,c(-1,-2)] #lets eliminate id and index

###############################################################
# Initial filtering of outliers by height and weight
###############################################################

#par(mfrow=c(1,2))
boxplot(data$height, main = "HEIGHT")
boxplot(data$weight, main = "WEIGHT")

ggplot(data, aes(x = height, y = weight)) +
  geom_point() +
  labs(x = "height", y = "weight") +
  theme_minimal()

data <- data[data$height >= 130 & data$height <= 230, ] #filter values to retain only those with biological sense
data <- data[data$weight >= 45,]

ggplot(data, aes(x = height, y = weight)) +
  geom_point() +
  labs(x = "height", y = "weight") +
  theme_minimal()

###############################################################
# Systolic pressure filtering
###############################################################

ggplot(data, aes(x = ap_hi, y = ap_lo)) +
  geom_point() +
  labs(x = "ap_hi", y = "ap_lo") +
  theme_minimal()

# filter data by sources found for normal values of systolic and diastolic pressure
data <- data[data$ap_hi <= 200 & data$ap_lo <= 140, ]
data <- data[data$ap_hi >= 80 & data$ap_lo >= 50, ]

ggplot(data, aes(x = ap_hi, y = ap_lo)) +
  geom_point() +
  labs(x = "ap_hi", y = "ap_lo") +
  theme_minimal()

###############################################################
# Detection of gender
###############################################################

weights_1 = data[data$gender == 1,]$weight
weights_2 = data[data$gender == 2,]$weight

mean(weights_1)
mean(weights_2)

heights_1 = data[data$gender == 1,]$height
heights_2 = data[data$gender == 2,]$height

mean(heights_1)
mean(heights_2)

# basically it can be considered that 1 = Female, 2 = Male

data$gender <- ifelse(data$gender == 1, "F", "M")
data$gender <- as.factor(data$gender)

###############################################################
# Factor data
###############################################################

table(data$cholesterol)
table(data$gluc)
table(data$smoke)
table(data$alco)
table(data$active)
table(data$cardio)

data$cholesterol <- as.factor(data$cholesterol)
data$gluc <- as.factor(data$gluc)
data$smoke <- as.factor(data$smoke)
data$alco <- as.factor(data$alco)
data$cardio <- as.factor(data$cardio)

###############################################################
# Data exploration
###############################################################

ggplot(data, aes(x = weight, y = height, color = gender)) +
  geom_point() +
  labs(x = "Weight", y = "Height", color = "Gender") +
  theme_minimal()

par(mfrow=c(1,3))
plot(density(data$age), main = "Age")
plot(density(data$height), main = "Height")
plot(density(data$weight), main = "Weight")
plot(density(data$ap_hi), main = "Ap Hi")
plot(density(data$ap_lo), main = "Ap Lo")
plot(density(data$BMI), main = "BMI")

p1 <- ggplot(data, aes(x = cholesterol)) +
  geom_bar() +
  labs(title = "Counts of Cholesterol Levels",
       x = "Cholesterol Levels",
       y = "Count")

p2 <- ggplot(data, aes(x = gluc)) +
  geom_bar() +
  labs(title = "Counts of glucose Levels",
       x = "Glucose Levels",
       y = "Count")

p3 <- ggplot(data, aes(x = smoke)) +
  geom_bar() +
  labs(title = "Counts of smoke status",
       x = "Smoke Levels",
       y = "Count")

p4 <- ggplot(data, aes(x = alco)) +
  geom_bar() +
  labs(title = "Counts of alcohol status",
       x = "Alcohol Levels",
       y = "Count")

p5<- ggplot(data, aes(x = active)) +
  geom_bar() +
  labs(title = "Counts of active status",
       x = "Active Levels",
       y = "Count")

p6 <- ggplot(data, aes(x = cardio)) +
  geom_bar() +
  labs(title = "Counts of cardio output Levels",
       x = "Cardio Levels",
       y = "Count")

grid.arrange(p1, p2, p3, p4, p5, p6, nrow = 2, ncol = 3)


###############################################################
# clustering
###############################################################
par(mfrow=c(1,1))

pca = prcomp(data[,c(1,3:6,13)], scale = TRUE)
pca_var <- pca$sdev^2
pca_var_prop <- pca_var / sum(pca_var)

plot(1:length(pca_var_prop), cumsum(pca_var_prop), type = "b", xlab = "Principal Component", ylab = "Proportion of Variance Explained", main = "Elbow Plot for PCA")


biplot(x = pca, scale = 0, cex = 0.2, col = c("blue4", "brown3"))

plot(pca$x[,1], pca$x[,2], 
     xlab = "PC1", ylab = "PC2", 
     main = "Scatter plot of PC1 vs PC2")

###############################################################
# Write data
###############################################################


# Assuming your dataset is named 'data'
#write.csv(data, file = file.path(file_path_data,"heart_data_processed.csv"), row.names = TRUE)

