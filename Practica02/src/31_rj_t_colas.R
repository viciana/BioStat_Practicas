# ---------------------------------------------------------------------
# 31_rj_t_colas.R
# Ejecuta datos/t_colas.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_t_colas.pdf
# Ejecutar desde Practica02:   Rscript src/31_rj_t_colas.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_t_colas.pdf", width = 5.4, height = 1.45)
source("datos/t_colas.R")
dev.off()
