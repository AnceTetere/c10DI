cleanUP <- function() {
  detach("package:XLConnect", unload = TRUE)
  gc()
  .jcall("java/lang/System", "V", "gc")
  
  if (file.exists("R/DATA/c10DI.csv")) {
    file.remove("R/DATA/c10DI.csv")}
  
  if (file.exists(paste0("R/DATA/BL_", substr(year, 3,4), "C", Q, ".xlsx"))) {
    file.remove(paste0("R/DATA/BL_", substr(year, 3,4), "C", Q, ".xlsx"))}
  
  if (file.exists(paste0("R/DATA/ICL_", substr(year, 3,4), "C", Q, ".xlsx"))) {
    file.remove(paste0("R/DATA/ICL_", substr(year, 3,4), "C", Q, ".xlsx"))}
  
  return("Ieejas dati dzēsti.")
}
