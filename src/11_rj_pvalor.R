# ---------------------------------------------------------------------
# 11_rj_pvalor.R
# Ejecuta datos/pvalor.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_pvalor.pdf
# Ejecutar desde practica02:   Rscript src/11_rj_pvalor.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_pvalor.pdf", width = 3.6, height = 2.6)
source("datos/pvalor.R")
dev.off()
