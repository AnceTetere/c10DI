addConfidentialities <- function(z, tab216) {

  z$EUR_X[z$conf != 0 & z$conf < 4] <- "10"  
  pk_Burti <- substr(z$N[z$EUR_X == "10"], 1, 1)
  
  for (j in 1:length(pk_Burti)) {
    
    kN <- z$N[substr(z$N, 1, 1) == pk_Burti[j] & z$EUR_X == "10"] 
    
    if(all(length(kN) == 1 & nchar(kN) == 3)) {

      subtab <- tab216[substr(tab216$Noz2, 1, 1) == pk_Burti[j] & 
                              nchar(tab216$Noz2) == 3 & 
                                  !(tab216$Noz2 %in% c("A-S", "B-S")) & 
                                    tab216$Noz2 != kN, ]
      
      
      colnames(subtab)[colnames(subtab) == "conf"] <- "G"
      sK <- subtab %>% slice(which.min(G)) %>% select(Noz2) %>% pull(Noz2)

      if(length(sK) == 1) {
        z$EUR_X[z$N == sK] <- "10"
      } else {stop("Trūkst izstrādes koda no 911. tabulas.")}}  
  }  
  
  rm(subtab, kN, sK, j, pk_Burti, tab216)
  return(z)
}
