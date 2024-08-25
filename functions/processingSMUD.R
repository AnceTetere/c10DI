#--------------I. CETURKŠŅA DATI NO SMUD ------------------------------

processingSMUD <- function() {
  #1. Saņemtie dati
  library(XLConnect)
  D_name <- paste0("LCI_", substr(year, 3, 4), "C", Q) # D_name: kā datu nosaukums
  wb <- loadWorkbook(paste0(path, "SMUD//", D_name, ".xlsx"),
                     create = FALSE,
                     password = NULL)
  worksheet <- readWorksheet(wb, sheet = 1)
  rm(wb)
  detach("package:XLConnect", unload = TRUE)
  
  #2. Izdala nepieciešamās ailes 
  y <- worksheet
  rm(worksheet)
  
  ceturksna_aile <- paste0("G", Q)
  y <- y[ , c("SV", "DAT", "NTABL", "NOZ2", ceturksna_aile)]
  rm(ceturksna_aile)
  
  #3. Pārbaudi datu datums atbilst
  ceturksna_datums = switch(
    as.character(Q),
    "1" = paste0("03", substr(year, 3, 4)), # jo 1. ceturksnis beidzas martā
    "2" = paste0("06", substr(year, 3, 4)), # jo 2. ceturksnis beidzas jūnijā
    "3" = paste0("09", substr(year, 3, 4)), # jo 3. ceturksnis beidzas septembrī
    "4" = paste0("12", substr(year, 3, 4)) # jo 4. ceturksnis beidzas decembrī
  )
  
  if(sum(y$DAT == ceturksna_datums) == nrow(y)) {
    y$DAT <- NULL
    print(paste0("PĀRBAUDE IZIETA: Datnē norādītais datums ", ceturksna_datums, " atbilst ", Q, ". ceturksnim."))
  } else {
    stop("SMUD datnē datums neatbilst ceturksnim.")
  }
  
  rm(ceturksna_datums)
  
  #4. Pārbaudi vai saņemtajā datnē atbilst visi N burti 2 zīmēs
  VEC_letters <- readRDS(paste0(base_path, "project code//templates//VEC_letters.rds"))
  
  if(sum(y$NOZ2 %in% VEC_letters) == nrow(y)) {
    print("PĀRBAUDE IZIETA: Atsūtītajos satos visi N burti ir 2-zīmēs.")
  } else {
    stop("Datnē iztrūkst N nozare.")
  }
  
  rm(VEC_letters)
  
  #5. Saglabā .RData formātā
  #assign(D_name, y)
  #save(list = D_name, file = paste0("SMUD//", D_name, ".RData"))
  #rm(list = D_name, D_name, y)
  return(y)
}
