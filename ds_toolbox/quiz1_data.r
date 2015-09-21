url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, destfile = "data_quiz1.csv")
data <- read.csv("getdata-data-ss06hid.csv")
summary(data$VAL)
values <- data %>% filter(VAL == 24)

dat <- read.table("xl2.csv")
dat <- data[18:23, 7:15]
sum(dat$Zip*dat$Ext,na.rm=T) 
names(dat)


dat <- ""


DT <- fread("datatable.csv")
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
0.003 0.000 0.002
system.time(mean(DT$pwgtp15,by=DT$SEX))
0 0 0
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
library(swirl)
system.time(DT[,mean(pwgtp15),by=SEX])
0.007 0.000 0.007
system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))



system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
0.001 0.000 0.001