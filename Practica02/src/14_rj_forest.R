# ---------------------------------------------------------------------
# 14_rj_forest.R
# Ejecuta datos/forest.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_forest.pdf
# Ejecutar desde practica02:   Rscript src/14_rj_forest.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_forest.pdf", width = 4.4, height = 2.4)
source("datos/forest.R")
dev.off()
