# ---------------------------------------------------------------------
# 29_rj_ic_logica.R
# Ejecuta datos/ic_logica.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_ic_logica.pdf
# Ejecutar desde Practica02:   Rscript src/29_rj_ic_logica.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_ic_logica.pdf", width = 4.6, height = 3.4)
source("datos/ic_logica.R")
dev.off()
