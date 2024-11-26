#Apstrādā datus*
t <- templates()
q <- quarterlyMerge(t$sD, t$t216, t$T1, t$T_rindas)

f_c10DI <- quarterlyBind(q$F_vec, q$f1_W_TOT, q$f2_OTH, q$f3_TOTAL, q$Q_rindas)
printoutF(t$T1, f_c10DI, q$F_rindas)

#IZDZĒŠ IEEJAS DATUS
cleanUP()
rm(list = ls())
