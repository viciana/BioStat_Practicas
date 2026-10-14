# ---------------------------------------------------------------------
# 12_rj_chi2.R
# Ejecuta datos/chi2.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_chi2.pdf
# Ejecutar desde practica02:   Rscript src/12_rj_chi2.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_chi2.pdf", width = 3.6, height = 2.8)
source("datos/chi2.R")
dev.off()
