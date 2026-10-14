# ---------------------------------------------------------------------
# 15_rj_pcr.R
# Ejecuta datos/pcr.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_pcr.pdf
# Ejecutar desde practica02:   Rscript src/15_rj_pcr.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_pcr.pdf", width = 4.4, height = 2.5)
source("datos/pcr.R")
dev.off()
