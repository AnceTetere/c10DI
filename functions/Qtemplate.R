Qtemplate <- function() {
  #1 Paņem tīru šablonu, kas nāk kopā ar šo kodu, izformē un saglabā
  load(paste0(base_path, "project code//templates//QTemplate.RData"))
  x <- QTemplate 
  rm(QTemplate)
  
  VEC_sectors <- readRDS(paste0(base_path, "project code//templates//VEC_sectors.rds"))
  VEC_letters <- readRDS(paste0(base_path, "project code//templates//VEC_letters.rds"))
  
  Q_rindas <- character(0)
  
  for (i in VEC_sectors) {
    x$T <- paste0(year, "Q", Q)
    x$N <- VEC_letters
    x$INDICATOR <- i
    x$rindas <- paste0(x$T, x$N, x$INDICATOR)
    Q_rindas <- append(Q_rindas, x$rindas)
    template_name <- paste0("t_", i, "_", substr(year, 3, 4), "Q", Q)
    assign(template_name, x)
    save(list = template_name, file = paste0(path, "izstrade/", template_name, ".RData"))
    rm(template_name)
  }
  
  #2 Saglabā arī Q rindu secību
  saveRDS(Q_rindas, file = paste0(path, "izstrade/Q_rindas.rds")) # Q: ceturkšņa rindas (Q = quarter)
  rm(i, x, VEC_letters, VEC_sectors)
  
  #3 Uzreiz arī izveido kopējo rindu secību
  T_rindas <- readRDS(paste0(path, "izstrade/T_rindas.rds"))
  F_rindas <- append(T_rindas, Q_rindas)
  saveRDS(F_rindas, file = paste0(path, "izstrade/F_rindas.rds")) # F: gala rindas (F = final)
  
  rm(Q_rindas, T_rindas, F_rindas)
  file.remove(paste0(path, "izstrade/T_rindas.rds"))
  
}
