corr <- function(directory, threshold = 0) {
  aux_corr <- function(filename) {
    data <- read.csv(file.path(directory, filename))
    nobs <- sum(complete.cases(data))
    if (nobs > threshold) {
      return (cor(data$nitrate, data$sulfate, use="complete.obs"))
    }
  }
  aux_corrs <- sapply(list.files(directory), aux_corr) 
  aux_corrs <- unlist(aux_corrs[!sapply(aux_corrs, is.null)])
  return (aux_corrs)
}

