processing_t216 <- function() {
  #1 t216 ņem no kādiem citiem pasūtījumiem
  library(XLConnect)
  D_name <- paste0("LB_", substr(year, 3, 4), "C", Q) # D_name: kā datu nosaukums
  wb <- loadWorkbook(paste0("../", year, "Q", Q, "/1_SMUD/", D_name, ".xlsx"),
                     create = FALSE,
                     password = NULL)
  worksheet <- readWorksheet(wb, sheet = 1)
  rm(wb, D_name)
  detach("package:XLConnect", unload = TRUE)
  
  #2 Izdala nepieciešamās ailes 
  y <- worksheet
  rm(worksheet)
  
  ceturksna_aile <- paste0("G", as.numeric(Q) * 3)
  y <- y[ , c("SV", "DAT", "NT", "NOZ2", ceturksna_aile)]
  
  ###---------!!! TODO: Skaties šo izvilkt, jo atkārtojas no processingSMUD()
  #3 Pārbauda datumsu atbilstību
  ceturksna_datums = switch(
    as.character(Q),
    "1" = paste0("03", substr(year, 3, 4)), # jo 1. ceturksnis beidzas martā
    "2" = paste0("06", substr(year, 3, 4)), # jo 2. ceturksnis beidzas jūnijā
    "3" = paste0("09", substr(year, 3, 4)), # jo 3. ceturksnis beidzas septembrī
    "4" = paste0("12", substr(year, 3, 4)) # jo 4. ceturksnis beidzas decembrī
  )
  
  if(sum(y$DAT == ceturksna_datums) == nrow(y)) {
    print(paste0("PĀRBAUDE IZIETA: SMUD datnē norādītais datums ", ceturksna_datums, " atbilst ", Q, ". ceturksnim."))
  } else {
    stop("SMUD datnē datums neatbilst ceturksnim.")
  }
  
  #4 No datnes izdala t216 un izformē
  y <- y[y$SV == "001" & y$nT == "216", ]
  y <- y[!(y$NOZ2 %in% c("C101", "C102", "C103", "C104", "C105", "C106_C109", "C107", "C108")), ]
  
  # Atkarībā no kurienes ņem t216, N komplekti atšķiras,
  # attiecīgi tos vienādo pret standartu, ko nes VEC_letters.rds
  if(sum(y$NOZ2 =="B-S") == 0) {
    new_row <- data.frame(
      SV = "001",
      DAT = ceturksna_datums,
      nT = "216",
      NOZ2 = "B-S",
      stringsAsFactors = FALSE
    )
    new_row[[ceturksna_aile]] <- 0
    y <- rbind(y, new_row)
    y[[ceturksna_aile]][y$NOZ2 =="B-S"] <- y[[ceturksna_aile]][y$NOZ2 == "TOTAL"] - y[[ceturksna_aile]][y$NOZ2 == "A"]
    rm(new_row, ceturksna_datums)
  } 
  
  if(sum(y$NOZ2 == "B-N") > 0) {y <- y[!(y$NOZ2 == "B-N"), ]}
  if(sum(y$NOZ2 == "B-S(bez O)") > 0) {y <- y[!(y$NOZ2 == "B-S(bez O)"), ]}
  rownames(y) <- NULL
  
  #5 Pārbauda vai saņemtajā datnē atbilst visi N burti 2 zīmēs
  VEC_letters <- readRDS(paste0(base_path, "project code/templates/VEC_letters.rds"))
  
  if(sum(VEC_letters %in% y$NOZ2) == nrow(y)) {
    print("PĀRBAUDE IZIETA.")
  } else {
    stop("Datnē iztrūkst N.")
  }
  
  #6 Noformē nummuru aili
  y[,ceturksna_aile] <- as.integer(round(y[,ceturksna_aile], 0))
  y <- y[match(VEC_letters, y$NOZ2), ]
  rownames(y) <- NULL
  rm(VEC_letters)
  
  #7 Saglabā .RData formātā pie oriģināliem
  t_216 <- y
  save(t_216, file = paste0(path, "SMUD/t216.RData"))
  rm(t_216)
  
  #8 Saglabā .RData formātā izmantošanai šai kodā
  colnames(y)[colnames(y) == ceturksna_aile] <- "conf"
  y <- y[ , c("NOZ2", "conf")]
  t216 <- y
  rm(y, ceturksna_aile)
  
  dir <- paste0(path, "izstrade")
  if(!dir.exists(dir)){dir.create(dir)}
  save(tab216, file = paste0(dir, "/confTOTAL.RData"))
  rm(dir)
  
  return(t216)
}
