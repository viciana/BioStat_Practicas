# ---------------------------------------------------------------------
# 17_rj_normal.R
# Ejecuta datos/normal.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_normal.pdf
# Ejecutar desde Practica02:   Rscript src/17_rj_normal.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_normal.pdf", width = 4.6, height = 3.1)
source("datos/normal.R")
dev.off()
