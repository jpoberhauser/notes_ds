#read required libraries into the session

library(plyr)
library(dplyr)
library(reshape2)
library(data.table)
###filenames are determined here and saved as r objects:
parent<-"UCI HAR Dataset/"
data_set<-c("train", "test")
subject_files<-paste0(parent,data_set,"/subject_",data_set,".txt")
feature_files<-paste0(parent,data_set,"/X_",data_set,".txt",sep="")
activity_files<-paste0(parent,data_set,"/y_",data_set,".txt",sep="")
#Reading the labels
feature_lab<-read.table(paste0(parent,"features.txt", sep=""))[,2]
activity_lab<-read.table(paste0(parent,"activity_labels.txt", sep=""))
names(activity_lab)<-c("activity_code","activity_name")

#Loading subject and feature data
subject_data <- do.call("rbind.fill",lapply(subject_files,function(x)read.table(x,col.names="subject")))
feature_data <- do.call("rbind.fill",lapply(feature_files,read.table))
names(feature_data) <- feature_lab

#selection
feats_selec <-as.character(feature_lab[grepl('mean\\(\\)|std\\(\\)',feature_lab)])
feature_data_selec <- feature_data[,feats_selec]

#Loading activity data
activity_data <- do.call("rbind.fill",lapply(activity_files,read.table))
names(activity_data) <- "activity_code"

#This is the join for the activity level
activity_data$activity_code<-factor(activity_data$activity_code)
activity_data_join <- join(activity_data,activity_lab, by="activity_code")

#FEatures that are used for binding
data_binded <- cbind(feature_data_selec, activity_data_join, subject_data)

#Using metl and cast, I can reshapethe dataset
melt_data <- melt(data_binded, id=c("subject", "activity_name"), measure.vars=feats_selec)
cast_data <- dcast(melt_data, activity_name + subject ~ variable, mean)

#I use the reshape package to castthe data back into the shape that I want it in
tidy_data <- cast_data[order(cast_data$subject, cast_data$activity_name),]    

tidy_data <- tidy_data[,c(2,1,3:length(names(tidy_data)))]

#I change the rownames to serve as an index
rownames(tidy_data) <- 1:nrow(tidy_data)

#I have to use the write.table function to write the tidy data to disk as a .txt file
write.table(tidy_data,file="tidy_dataset.txt", row.names=FALSE)
