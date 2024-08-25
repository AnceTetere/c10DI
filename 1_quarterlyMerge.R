#1. Ielādē datni
d_name <- paste0("LCI_", substr(year, 3, 4), "C", Q) 
load(paste0("SMUD/", d_name, ".RData"))
x <- get(d_name) 
rm(list = d_name, d_name)

#2. Sašķel datni
x$nT <- factor(x$nT)
levels(x$nT)

d_split <- split(x, x$nT)
names(d_split) <- paste0("d_", names(d_split))
d_vec <- names(d_split)
list2env(d_split, envir = .GlobalEnv)
rm(d_split, x)

#3. Paņem t216
load(paste0(path, "izstrade//intermediate_tables//confTOTAL.RData"))

#4. Ievieto datus šablonos.
ailes <- readRDS(paste0(base_path, "project code//templates//ailes.rds"))
ailes1 <- append(ailes, "conf")
rm(ailes)

VEC_letters <- readRDS(paste0(base_path, "project code//templates//VEC_letters.rds"))

F_vec <- character(0)

for(i in 1:length(d_vec)) {
  d <- get(d_vec[i])
  t <- switch (d_vec[i],
    "d_328" = paste0("t_LWT_", substr(year, 3, 4), "Q", Q),
    "d_329" = paste0("t_LO_", substr(year, 3, 4), "Q", Q),
    "d_330" = paste0("t_LT_", substr(year, 3, 4), "Q", Q)
  )
  
  load(paste0("izstrade//intermediate_tables//", t, ".RData"))
  x <- get(t)
  rm(list = c(t, d_vec[i]))
  
  x1 <- d[ , c("NOZARE2", paste0("G", Q))]
  rm(d)
  
  #first merge
  y <- merge(x, x1, by.x = "NACE", by.y = "NOZARE2")  
  rm(x, x1)
  
  y$EUR <- y[ , paste0("G", Q)]
  y <- y[match(VEC_letters, y$NACE), ]
  rownames(y) <- NULL
  
  #second merge
  z <- merge(y, t216, by.x = "NACE", by.y = "NOZARE2")
  z <- z[match(VEC_letters, z$NACE), ailes1]
  rownames(z) <- NULL
  rm(y)
  
  Z_name <- paste0("f", i, "_", substr(t, 3, nchar(t))) 
  assign(Z_name, addConfidentialities(z, t216))
  
  save(list = Z_name, file = paste0("izstrade//intermediate_tables//", Z_name, ".RData"))
  F_vec <- append(F_vec, Z_name)
  
#  file.remove(t)
  rm(t, Z_name)
  }

rm(i, VEC_letters, d_vec, ailes1, z, t216)

#4. Savieno

f_c10DI <- rbind(get(F_vec[1]), get(F_vec[2]), get(F_vec[3]))
rm(list = F_vec, F_vec)

Q_rindas <- readRDS("izstrade//intermediate_tables//Q_rindas.rds")
f_c10DI <- f_c10DI[match(Q_rindas, f_c10DI$rindas), ]
rownames(f_c10DI) <- NULL

#5. Un saglabā
save(f_c10DI, file = paste0("izstrade//intermediate_tables//gatC.RData"))

rm(Q_rindas)
