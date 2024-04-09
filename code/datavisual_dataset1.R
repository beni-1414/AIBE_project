
###############################################################
# Data loading
###############################################################

library(ggplot2)

cd = getwd()
parent_dir <- dirname(cd)
file_path_data = file.path(parent_dir, "data")

data = read.table(file.path(file_path_data, "heart_data.csv"), header = T, sep = ",")

###############################################################
# Initial modifications
###############################################################

data$BMI = round(data$weight / (data$height / 100), 2) #add BMI as variable

data$age = round(data$age / 365, 2) #age is initially given in days, lets put in years

data = data[,c(-1,-2)] #lets eliminate id and index

###############################################################
# Initial filtering of outliers by height and weight
###############################################################

par(mfrow=c(1,2))
boxplot(data$height, main = "HEIGHT")
boxplot(data$weight, main = "WEIGHT")

ggplot(data, aes(x = height, y = weight)) +
  geom_point() +
  labs(x = "height", y = "weight") +
  theme_minimal()

data <- data[data$height >= 130 & data$height <= 230, ]

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


###############################################################
# Write data
###############################################################


# Assuming your dataset is named 'data'
#write.csv(data, file = file.path(file_path_data,"heart_data_processed.csv"), row.names = TRUE)

