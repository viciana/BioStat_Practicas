# ---------------------------------------------------------------------
# 34_rj_ic_fumador.R
# Ejecuta datos/ic_fumador.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_ic_fumador.pdf
# Ejecutar desde Practica02:   Rscript src/34_rj_ic_fumador.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_ic_fumador.pdf", width = 3.6, height = 1.9)
source("datos/ic_fumador.R")
dev.off()
