rankall <- function(outcome, num = "best") {
        ## Read outcome data
        ## Read outcome data
        df <- read.csv("./outcome-of-care-measures.csv", colClasses = "character",na.strings="Not Available")
        
        ## Check that state and outcome are valid
        ok_parameter1 = c("heart attack","heart failure","pneumonia")
        if (!outcome %in% ok_parameter1) { stop("invalid outcome")}
        
        ok_parameter2 = unique(df[,"State"])
        if (!state %in% ok_parameter2) stop("invalid state")

        ## For each state, find the hospital of the given rank
        #column name
        colnamesvec <-  c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure", "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
        colName <- colnamesvec[match(outcome,ok_parameter1)]
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name
        hospital<-character(0)
        for (i in seq_along(ok_parameter2)) {

                dfa <- df[df$State==ok_parameter2[i],]
                
                # order data by outcome
                sort <- dfa[order(as.numeric(dfa[[colName]]),dfa[["Hospital.Name"]],decreasing=FALSE,na.last=NA), ]
                
                #handle num input
                this.num = num
                if (this.num=="best") this.num = 1
                if (this.num=='worst') this.num = nrow(sort)
                
                hospital[i] <- sort[this.num,"Hospital.Name"]
        }
        

        data.frame(hospital=hospital,state=ok_parameter2,row.names=ok_parameter2)
        
}
        