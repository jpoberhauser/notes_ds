best <- function(state, outcome) {
        ## Read outcome data
        df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        ## Check that state and outcome are valid
        ok_parameter1 = c("heart attack","heart failure","pneumonia")
        if (!outcome %in% ok_parameter1) { stop("invalid outcome")}
        
        ok_parameter2 = unique(df[,"State"])
        if (!state %in% ok_parameter2) stop("invalid state")
        
        colnamesvec <-  c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure", "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
        colName <- colnamesvec[match(outcome,ok_parameter1)]
        
        dfa <- df[df$State==state,]
        minim_pos <- which.min(as.double(dfa[,colName]))
        ## Return hospital name in that state with lowest 30-day death
        ## rate
        dfa[minim_pos,"Hospital.Name"]
}