# ---------------------------------------------------------------------
# 10_rj_ic.R
# Ejecuta datos/ic.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_ic.pdf
# Ejecutar desde practica02:   Rscript src/10_rj_ic.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_ic.pdf", width = 4.6, height = 3.6)
source("datos/ic.R")
dev.off()
