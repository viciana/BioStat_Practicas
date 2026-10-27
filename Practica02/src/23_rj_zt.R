# ---------------------------------------------------------------------
# 23_rj_zt.R
# Ejecuta datos/zt.R (código R/Rj que se da a los alumnos) y guarda
# img/rj_zt.pdf
# Ejecutar desde Practica02:   Rscript src/23_rj_zt.R
# ---------------------------------------------------------------------
cairo_pdf("img/rj_zt.pdf", width = 4.8, height = 2.9)
source("datos/zt.R")
dev.off()
