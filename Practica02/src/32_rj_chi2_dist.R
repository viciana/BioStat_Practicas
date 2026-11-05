# ---------------------------------------------------------------------
# 32_rj_chi2_dist.R
# Ejecuta datos/chi2_dist.R (simulación autónoma, código R/Rj que se da a
# los alumnos) y guarda img/rj_chi2_dist.pdf
# Ejecutar desde Practica02:   Rscript src/32_rj_chi2_dist.R
# ---------------------------------------------------------------------
cairo_pdf("img/rj_chi2_dist.pdf", width = 5.4, height = 1.5)
source("datos/chi2_dist.R")
dev.off()
