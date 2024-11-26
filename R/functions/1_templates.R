templates <- function() {
  
  sD <- processingSMUD()
  t216 <- processingCONF()
  
  tR <- Ttemplate() #no: t Result
  T1 <- tR$T1
  T_rindas <- tR$T_rindas
  rm(tR)
  
  return(list(sD = sD, t216 = t216, T1 = T1, T_rindas = T_rindas))
}
