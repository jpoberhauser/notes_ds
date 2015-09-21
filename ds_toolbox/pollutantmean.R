pollutantmean <- function(directory, pollutant, id = 1:332) {
  id_aux<-sprintf("%03d",id)
  id_aux1<-paste(id_aux,".csv",sep="")
  data = data.frame()
  for (i in id_aux1){
    b <- paste(directory,"/",i,sep="")
    data_aux<-read.csv(b)
    data<-rbind(data,data_aux)
  }
  data1<-data[which(names(data) == pollutant)]
  bad <- is.na(data1)
  data2<-data1[!bad]
  mean(data2) 
}


