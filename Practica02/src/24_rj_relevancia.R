# ---------------------------------------------------------------------
# 24_rj_relevancia.R
# Ejecuta datos/relevancia.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_relevancia.pdf
# Ejecutar desde practica02:   Rscript src/24_rj_relevancia.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_relevancia.pdf", width = 4.6, height = 2.1)
source("datos/relevancia.R")
dev.off()
