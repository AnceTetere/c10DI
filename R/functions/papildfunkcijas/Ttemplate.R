Ttemplate <- function() {

  if (file.exists(("R/DATA/c10DI.csv"))) {
    T1 <- read.csv2("R/DATA/c10DI.csv")
  } else {stop("Projekta c10DI mapē NAV faila R/DATA/c10DI.csv")}

  T1$rindas <- paste0(T1$TIME, T1$N, T1$I)
  T_rindas <- T1$rindas 

  for(i in 1:ncol(T1)) {
    T1[is.na(T1[ , i]), i] <- "" 
  }
  rm(i)
  
  return(list(T1 = T1, T_rindas = T_rindas))
}
