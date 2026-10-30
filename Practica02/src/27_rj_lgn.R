# ---------------------------------------------------------------------
# 27_rj_lgn.R
# Ejecuta datos/lgn.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_lgn.pdf
# Ejecutar desde Practica02:   Rscript src/27_rj_lgn.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_lgn.pdf", width = 4.6, height = 2.8)
source("datos/lgn.R")
dev.off()
