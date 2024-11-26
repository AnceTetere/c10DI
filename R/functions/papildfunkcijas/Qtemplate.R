Qtemplate <- function(T_rindas) {
  load("R/templates/QTemplate.RData")
  x <- QTemplate 
  rm(QTemplate)
  
  VEC_sectors <- readRDS("R/templates/VEC_sectors.rds")
  VEC_letters <- readRDS("R/templates/VEC_letters.rds")
  
  Q_rindas <- character(0)
  
  for (i in VEC_sectors) {
    x$TIME <- paste0(year, "Q", Q)
    x$N <- VEC_letters
    x$I <- i
    x$rindas <- paste0(x$TIME, x$N, x$I)
    
    Q_rindas <- append(Q_rindas, x$rindas) #tas lai noturētu kārtību
    template_name <- paste0("t_", i)
    assign(template_name, x, envir = environment())
    rm(template_name)
  }
  
  rm(i, x, VEC_letters, VEC_sectors)
  
  F_rindas <- append(T_rindas, Q_rindas)
  rm(T_rindas)
  
  return(list(t_TOTAL = t_TOTAL,
              t_WAG_TOT = t_WAG_TOT,
              t_OTH = t_OTH,
              F_rindas = F_rindas,
              Q_rindas = Q_rindas))
}
