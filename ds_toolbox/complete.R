complete <- function(directory, id = 1:332) {
                data=data.frame()
                    for (i in id){
                        obs = i + 1
                        id_aux1<-paste(sprintf("%03d",i),".csv",sep="")
                        b <- paste(directory,"/",id_aux1,sep="")
                        data_aux<-read.csv(b)
            
                        temp2 <- data_aux %>%
                        filter(!is.na(nitrate), !is.na(sulfate)) %>% 
                        summarise(id = i,
                                  nobs = n())
                        
                        data[obs,"id"] <- temp2[,1]
                        data[obs,"nobs"] <- temp2[,2]
                    }
                dataclean <- data %>% filter(!is.na(id))
                dataclean
}

