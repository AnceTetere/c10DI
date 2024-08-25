#Iepriekšējo nodevumu lieto sākuma šablonam

Ttemplate <- function() {
  #1 Paņem iepriekšējā nodevumu... 
  T1 <- read.csv2(paste0(base_path, "d_fails/c10DI.csv"))
  T1$rindas <- paste0(T1$T, T1$N, T1$INDICATOR)
  T_rindas <- T1$rindas
  
  saveRDS(T_rindas, file = paste0(path, "izstrade/T_rindas.rds"))
  
  for(i in 1:ncol(T1)) {
    T1[is.na(T1[ , i]), i] <- "" 
  }
  rm(T_rindas, i)
  
  #2 Saglabā, kā sākotnējo datni
  dir <- paste0(path,"izstrade/final_tables")
  if(!dir.exists(dir)) {dir.create(dir)}
  save(T1, file = paste0(dir, "/1_initial_c10DI_", year, "Q", Q, ".RData"))
  
  return(T1)
}
