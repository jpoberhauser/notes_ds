hw<-read.csv("hw1_data.csv")
Extract the subset of rows of the data frame where Ozone values are above 31 
and Temp values are above 90. 
What is the mean of Solar.R in this subset?
334.0
185.9
205.0
212.8
hw1 <- subset(hw , Ozone > 31 & Temp > 90)
mean(hw1$Solar.R)



What is the mean of "Temp" when "Month" is equal to 6?
summary(hw$Month)
hw6<-hw[which(hw$Month == 6),]

What was the maximum ozone value in the month of May (i.e. Month = 5)?
hw6<-hw[which(hw$Month == 5),]
summary(hw6$Ozone)
