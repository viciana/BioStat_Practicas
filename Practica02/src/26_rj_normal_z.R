# ---------------------------------------------------------------------
# 26_rj_normal_z.R
# Ejecuta datos/normal_z.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_normal_z.pdf
# Ejecutar desde Practica02:   Rscript src/26_rj_normal_z.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_normal_z.pdf", width = 4.3, height = 2.55)
source("datos/normal_z.R")
dev.off()
