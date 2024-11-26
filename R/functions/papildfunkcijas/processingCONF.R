processingCONF <- function() {

  if (file.exists(paste0("R/DATA/BL_", substr(year, 3, 4), "C", Q, ".xlsx"))) {
    wb <- loadWorkbook(paste0("R/DATA/BL_", substr(year, 3, 4), "C", Q, ".xlsx"),
                       create = FALSE,
                       password = NULL)
  } else {stop("Datu mapē R/DATA nav atrodama datne ar nosaukumu BL_", substr(year, 3, 4), "C", Q, ".xlsx")}
  
  y <- readWorksheet(wb, sheet = 1)
  rm(wb)

  c_aile <- paste0("G", as.numeric(Q) * 3)
  y <- y[ , c("VSN", "DAT", "nT", "noz2", c_aile)]
  
  y$noz2[y$noz2 == "TOTAL"] <- "A-S"
    cat(datuma_parbaude(y))
  
  y <- y[y$VSN == "001" & y$nT == "216", ]
  y <- y[!(y$noz2 %in% c("C101", "C102", "C103", "C104", "C105", "C106_C109", "C107", "C108")), ]
  
  if(sum(y$noz2 =="B-S") == 0) {
    new_row <- data.frame(
      VSN = "001",
      DAT = c_datums,
      nT = "216",
      noz2 = "B-S",
      stringsAsFactors = FALSE
    )
    new_row[[c_aile]] <- 0
    y <- rbind(y, new_row)
    y[[c_aile]][y$noz2 =="B-S"] <- y[[c_aile]][y$noz2 == "TOTAL"] - y[[c_aile]][y$noz2 == "A"]
    rm(new_row, c_datums)
  } 
  
  if(sum(y$noz2 == "B-N") > 0) {y <- y[!(y$noz2 == "B-N"), ]}
  if(sum(y$noz2 == "B-S(bez O)") > 0) {y <- y[!(y$noz2 == "B-S(bez O)"), ]}
  rownames(y) <- NULL
  
  if(sum(readRDS("R/templates/VEC_letters.rds") %in% y$noz2) == nrow(y)) {
    print("PĀRBAUDE IZIETA.")
  } else {stop("Datnē iztrūkst N nozare.")}
  

  y[,c_aile] <- as.integer(round(y[,c_aile], 0))
  y <- y[match(readRDS("R/templates/VEC_letters.rds"), y$noz2), ]
  rownames(y) <- NULL
  
  colnames(y)[colnames(y) == c_aile] <- "conf"
  t216 <- y[ , c("noz2", "conf")]
  rm(y, c_aile)
    
  return(t216)
}
