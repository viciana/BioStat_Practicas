# ---------------------------------------------------------------------
# 22_rj_binomial.R
# Ejecuta datos/binomial.R (código R que se da a los alumnos; no usa datos)
# y guarda img/rj_binomial.pdf
# Ejecutar desde Practica02:   Rscript src/22_rj_binomial.R
# ---------------------------------------------------------------------
cairo_pdf("img/rj_binomial.pdf", width = 9.5, height = 2.8)
source("datos/binomial.R")
dev.off()
