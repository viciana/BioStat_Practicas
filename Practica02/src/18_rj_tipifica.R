# ---------------------------------------------------------------------
# 18_rj_tipifica.R
# Ejecuta datos/tipifica.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_tipifica.pdf
# Ejecutar desde Practica02:   Rscript src/18_rj_tipifica.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_tipifica.pdf", width = 6.2, height = 3.6)
source("datos/tipifica.R")
dev.off()
