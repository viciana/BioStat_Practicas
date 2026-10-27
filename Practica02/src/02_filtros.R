# ---------------------------------------------------------------------
# 02_filtros.R
# datos/poblacion.omv -> datos/poblacion_filtros.omv, el fichero que se usa
# en clase: el mismo con dos filtros de jamovi ya creados (e inactivos),
# para pasar de la población a una muestra con un solo clic:
#   Filtrar 1: Muestra_grande == 1   (n = 300)
#   Filtrar 2: Muestra_peq == 1      (n = 30; está dentro de la grande)
# Sin filtros activos se analiza la población (N = 2000).
# Ejecutar desde Practica02:   Rscript src/02_filtros.R
# ---------------------------------------------------------------------
source("src/omv_enteros.R")
pob <- read.csv("datos/poblacion.csv")
anade_filtros("datos/poblacion.omv", "datos/poblacion_filtros.omv", list(
  list(formula = "Muestra_grande == 1", valores = pob$Muestra_grande, desc = "Muestra de 300"),
  list(formula = "Muestra_peq == 1",    valores = pob$Muestra_peq,    desc = "Muestra de 30")))
