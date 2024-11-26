quarterlyMerge <- function(sD, t216, T1, T_rindas) {

  qR <- Qtemplate(T_rindas) #no q result

  t_TOTAL <- qR$t_TOTAL
  t_WAG_TOT <- qR$t_WAG_TOT
  t_LC_OTH <- qR$t_LC_OTH
  
  F_rindas <- qR$F_rindas
  Q_rindas <- qR$Q_rindas
  rm(T_rindas, qR)
  
  sD$nT <- factor(sD$nT)
  
  d_split <- split(sD, sD$nT)
  names(d_split) <- paste0("d_", names(d_split))
  d_vec <- names(d_split)
  list2env(d_split, envir = environment())
  rm(d_split, sD)
  
  #2 Ievieto datus šablonos.
  ailes <- append(readRDS("R/templates/ailes.rds"), "conf")
  VEC_letters <- readRDS("R/templates/VEC_letters.rds")
  F_vec <- character(0)

  for(i in 1:length(d_vec)) {
    d <- get(d_vec[i])
    t <- switch (d_vec[i],
                 "d_328" = "t_WAG_TOT",
                 "d_329" = "t_LC_OTH",
                 "d_330" = "t_TOTAL"
    )
    
    x <- get(t)
    x1 <- d[ , c("NOZARE2", paste0("G", Q))]
    rm(list = c(t, d_vec[i]), d)
    
    #first merge
    y <- merge(x, x1, by.x = "NACE", by.y = "NOZARE2")  
    rm(x, x1)
    
    y$EUR <- y[ , paste0("G", Q)]
    y <- y[match(VEC_letters, y$NACE), ]
    rownames(y) <- NULL

    #second merge
    z <- merge(y, t216, by.x = "NACE", by.y = "NOZARE2")
    z <- z[match(VEC_letters, z$NACE), ailes]
    rownames(z) <- NULL
    rm(y)
    
    Z_name <- paste0("f", i, "_", substr(t, 3, nchar(t))) 
    assign(Z_name, addConfidentialities(z, t216), envir = environment())
    F_vec <- append(F_vec, Z_name)
    
    rm(t, Z_name)
  }
  
  rm(i, VEC_letters, d_vec, ailes, z, t216)
  
  return(list(
    f1_LC_WAG_TOT = f1_LC_WAG_TOT, 
    f2_LC_OTH = f2_LC_OTH,
    f3_LC_TOTAL = f3_LC_TOTAL,
    F_vec = F_vec,
    Q_rindas = Q_rindas,
    F_rindas = F_rindas))
  
}
