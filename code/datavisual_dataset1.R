
###############################################################
# Data loading
###############################################################

library(ggplot2)

data = read.table("heart_data.csv", header = T, sep = ",")

###############################################################
# Initial modifications
###############################################################

data$BMI = round(data$weight / (data$height / 100), 2)

data$age = round(data$age / 365, 2)

data = data[,c(-1,-2)]

###############################################################
# Initial filtering of outliers by height and weight
###############################################################

boxplot(data$height, main = "HEIGHT")
boxplot(data$weight, main = "WEIGHT")

outliers_height = boxplot(data$height, plot = F)$out
outliers_weight = boxplot(data$weight, plot = F)$out


ids_out_height = which(outliers_height %in% data$height,)
ids_out_weight = which(outliers_weight %in% data$weight,)

all_ids <- union(ids_out_height, ids_out_weight)

data = data[-all_ids,]

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

library(ggplot2)
ggplot(data, aes(x = weight, y = height, color = gender)) +
  geom_point() +
  labs(x = "Weight", y = "Height", color = "Gender") +
  theme_minimal()

