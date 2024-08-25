datuma_parbaude <- function(y) {
ceturksna_datums = switch(
  as.character(Q),
  "1" = paste0("03", substr(year, 3, 4)),
  "2" = paste0("06", substr(year, 3, 4)), 
  "3" = paste0("09", substr(year, 3, 4)),
  "4" = paste0("12", substr(year, 3, 4)) 
)

if(sum(y$DAT == ceturksna_datums) == nrow(y)) {
  atb <- paste0("PĀRBAUDE IZIETA: Datnē norādītais datums ", ceturksna_datums, " atbilst.")
} else {
  stop("Datnē datumi neatbilst.")
}

return(atb)
}
