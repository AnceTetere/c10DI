quarterlyBind <- function(F_vec, f1_WAG_TOT, f2_OTH, f3_TOTAL, Q_rindas) {

  f_c10DI <- rbind(f1_WAG_TOT, f2_OTH, f3_TOTAL)
  rm(list = F_vec, F_vec)
  
  f_c10DI <- f_c10DI[match(Q_rindas, f_c10DI$rindas), ]
  rownames(f_c10DI) <- NULL
  rm(Q_rindas)
  
  return(f_c10DI)
}
