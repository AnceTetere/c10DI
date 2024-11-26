processingSMUD <- function() {

  if (file.exists(paste0("R/DATA/ICL_", substr(year, 3, 4), "C", Q, ".xlsx"))) {
  wb <- loadWorkbook(paste0("R/DATA/ICL_", substr(year, 3, 4), "C", Q, ".xlsx"),
                     create = FALSE,
                     password = NULL)
  } else {stop("Datu mapē R/DATA nav atrodama datne ar nosaukumu ICL_", substr(year, 3, 4), "C", Q, ".xlsx")}
  y <- readWorksheet(wb, sheet = 1)
  rm(wb)
    
  c_aile <- paste0("G", Q)
  y <- y[ , c("VSN", "DAT", "nT", "noz2", c_aile)]
  rm(c_aile)
  
  y$noz2[y$noz2 == "TOTAL"] <- "A-S"  
  
  cat(datuma_parbaude(y))
  
  if(sum(y$noz2 %in% readRDS("R/templates/VEC_letters.rds")) == nrow(y)) {
    print("PĀRBAUDE IZIETA.")
  } else {stop("Datnē iztrūkst N nozare.")}
  
  return(y)
}
