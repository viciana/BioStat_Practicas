# ---------------------------------------------------------------------
# 33_rj_ic_colesterol.R
# Ejecuta datos/ic_colesterol.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_ic_colesterol.pdf
# Ejecutar desde Practica02:   Rscript src/33_rj_ic_colesterol.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_ic_colesterol.pdf", width = 3.6, height = 1.9)
source("datos/ic_colesterol.R")
dev.off()
