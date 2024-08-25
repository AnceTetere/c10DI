#I. DATI NO SMUD
x <- processingSMUD()
t216 <- processingCONF()

#II. c10DI LIELAIS ŠABLONS
T1 <- Ttemplate()

#III. c10DI ŠABLONS
Qtemplate()

#IV. Sagriež datni un sapludinā to ar šabloniem

#1. Sašķel datni
x$nT <- factor(x$nT)
levels(x$nT)

d_split <- split(x, x$nT)
names(d_split) <- paste0("d_", names(d_split))
d_vec <- names(d_split)
list2env(d_split, envir = .GlobalEnv)
rm(d_split, x)

#2 Ievieto datus šablonos.
ailes <- readRDS(paste0(base_path, "project code/templates/ailes.rds"))
ailes1 <- append(ailes, "conf")
rm(ailes)

VEC_letters <- readRDS(paste0(base_path, "project code/templates/VEC_letters.rds"))
F_vec <- character(0)

for(i in 1:length(d_vec)) {
  d <- get(d_vec[i])
  t <- switch (d_vec[i],
               "d_328" = paste0("t_LC_WAG_TOT_", substr(year, 3, 4), "Q", Q),
               "d_329" = paste0("t_LC_OTH_", substr(year, 3, 4), "Q", Q),
               "d_330" = paste0("t_LC_TOTAL_", substr(year, 3, 4), "Q", Q)
  )
  
  load(paste0(path, "izstrade/", t, ".RData"))
  x <- get(t)
  rm(list = c(t, d_vec[i]))
  
  x1 <- d[ , c("NOZ2", paste0("G", Q))]
  rm(d)
  
  #first merge
  y <- merge(x, x1, by.x = "N", by.y = "NOZ2")  
  rm(x, x1)
  
  y$EUR <- y[ , paste0("G", Q)]
  y <- y[match(VEC_letters, y$N), ]
  rownames(y) <- NULL
  
  #second merge
  z <- merge(y, t216, by.x = "N", by.y = "NOZ2")
  z <- z[match(VEC_letters, z$N), ailes1]
  rownames(z) <- NULL
  rm(y)
  
  Z_name <- paste0("f", i, "_", substr(t, 3, nchar(t))) 
  assign(Z_name, addConfidentialities(z, t216))
  
  save(list = Z_name, file = paste0(path, "izstrade/", Z_name, ".RData"))
  F_vec <- append(F_vec, Z_name)
  
  #  file.remove(t)
  rm(t, Z_name)
}

rm(i, VEC_letters, d_vec, ailes1, z, tab216)

#4. Savieno

f_c10DI <- rbind(get(F_vec[1]), get(F_vec[2]), get(F_vec[3]))
rm(list = F_vec, F_vec)

Q_rindas <- readRDS(paste0(path,"izstrade/Q_rindas.rds"))
f_c10DI <- f_c10DI[match(Q_rindas, f_c10DI$rindas), ]
rownames(f_c10DI) <- NULL

#5. Un saglabā
save(f_c10DI, file = paste0(path, "izstrade/gatC.RData"))

rm(Q_rindas)
