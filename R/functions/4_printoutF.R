printoutF <- function(T1, C2, F_rindas) {
  
  C2$conf <- NULL
  
  C2$EUR <- sprintf("%.2f", round(as.numeric(C2$EUR), 2))
  rownames(C2) <- NULL
  
  C2$EUR[C2$EUR_X == "10"] <- ""
  C2$EUR[is.na(C2$EUR)] <- ""
  C2$EUR_X[is.na(C2$EUR_X)] <- ""
  
  F3 <- rbind(T1, C2)
  rm(T1, C2)
  
  if(length(F_rindas) == nrow(F3)) {
    F3 <- F3[match(F_rindas, F3$rindas), ]
    rownames(F3) <- NULL
  } else {
    stop("Kārtošanas vektora garums neatbilst rindu skaitam gala tabulā F3. \n")
  }
  
  if (Q != 1) {
    for (q in Q:2) {
      if (all(F3$EUR_X[F3$TIME == paste0(year, "Q", q)] != F3$EUR_X[F3$TIME == paste0(year, "Q", q-1)])) {
        stop("4_printoutF: konfidencialitātes nesakrīt. \
           Izdomā līdz galam, kā te sakārtor")
      }
    }
  }
  
  #sakārtot rindas
  if(length(F_rindas) == nrow(F3)) {
    F3 <- F3[match(F_rindas, F3$rindas), ]
    rownames(F3) <- NULL
  } else {
    stop("Kārtošanas vektora garums neatbilst rindu skaitam gala tabulā F3. \n")
  }
  
  #4 noņemt rindu aili
  F3$rindas <- NULL
  
  #5 CSV formātā.
  write.table(F3, "R/OUTPUT/c10DI_final.csv", sep = ";", col.names = TRUE, row.names = FALSE, qmethod = "double")
  
  return(cat("Gatavā tabula atrodas R/OUTPUT/c10DI_final.csv"))
}
