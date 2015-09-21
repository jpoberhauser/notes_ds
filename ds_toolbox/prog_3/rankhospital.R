rankhospital <- function(state, outcome, num = "best") {
        ## Read outcome data
        df <- read.csv("./outcome-of-care-measures.csv", colClasses = "character",na.strings="Not Available")
        
        ## Check that state and outcome are valid
        ## Check that state and outcome are valid
        ok_parameter1 = c("heart attack","heart failure","pneumonia")
        if (!outcome %in% ok_parameter1) { stop("invalid outcome")}
        
        ok_parameter2 = unique(df[,"State"])
        if (!state %in% ok_parameter2) stop("invalid state")
        
        #column name
        colnamesvec <-  c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure", "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
        colName <- colnamesvec[match(outcome,ok_parameter1)]
        #state
        dfa <- df[df$State==state,]
        
        ## Return hospital name in that state with the given rank
        ## 30-day death rate
        sort <- dfa[order(as.numeric(dfa[[colName]]),dfa[["Hospital.Name"]],decreasing=FALSE,na.last=NA), ]
        
        if (num=='worst') num = nrow(sort)
        if (num=="best") num = 1
        
        
        
        solution <- sort[num,"Hospital.Name"]
        print(solution)
}