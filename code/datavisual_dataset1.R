data = read.table("heart_data.csv", header = T, sep = ",")


data$BMI = data$weight / (data$height / 100)


plot(data$height, data$weight)


data$age = data$age / 365
