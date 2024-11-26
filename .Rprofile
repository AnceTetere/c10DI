#Definē periodu, par kuru tiek veidota atskaite.
if (interactive()) {
  cat("Ievadīt gadu, par kuru tiek veidota datne:\n")
  year <- readline()
  
  cat("Ievadīt ceturksni, par kuru tiek veidota datne:\n")
  Q <- readline()
  message("\n c10DI izstrāde par ", year, ". gada ", Q, ".ceturksni.")}

#Notīra no iepriekšējās reizes palikušo gala failu, lai nesajaucas.
if (file.exists("R/OUTPUT/c10DI_final.csv")) {
  file.remove("R/OUTPUT/c10DI_final.csv")}

#Ielādē pakotnes
library(tidyverse)
library(magrittr)
library(XLConnect)
library(rJava)
options(java.parameters = "-Dorg.apache.logging.log4j.simplelog.StatusLogger.level=OFF")

#Ielādē funkcijas
source("R/functions/1_templates.R")
source("R/functions/2_quarterlyMerge.R")
source("R/functions/3_quarterlyBind.R")
source("R/functions/4_printoutF.R")
source("R/functions/papildfunkcijas/datuma_parbaude.R")
source("R/functions/papildfunkcijas/processingSMUD.R")
source("R/functions/papildfunkcijas/processingCONF.R")
source("R/functions/papildfunkcijas/Ttemplate.R")
source("R/functions/papildfunkcijas/Qtemplate.R")
source("R/functions/papildfunkcijas/addConfidentialities.R")
source("R/functions/papildfunkcijas/cleanUp.R")

#Palaiž programmu
source("R/MAIN.R")
