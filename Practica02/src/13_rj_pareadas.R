# ---------------------------------------------------------------------
# 13_rj_pareadas.R
# Ejecuta datos/pareadas.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_pareadas.pdf
# Ejecutar desde practica02:   Rscript src/13_rj_pareadas.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_pareadas.pdf", width = 4.4, height = 2.6)
source("datos/pareadas.R")
dev.off()
