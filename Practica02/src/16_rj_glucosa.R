# ---------------------------------------------------------------------
# 16_rj_glucosa.R
# Ejecuta datos/glucosa.R (simulación autónoma, código R/Rj que se da a
# los alumnos) y guarda img/rj_glucosa.pdf (diapositiva «glucosa basal y
# diagnóstico de diabetes»).  Sustituye a las 5 figuras de ../S2
# (no-diabeticos, diabeticos, ambos, diabeticos2, ambos2; HH::norm.curve)
# Ejecutar desde practica02:   Rscript src/16_rj_glucosa.R
# ---------------------------------------------------------------------
cairo_pdf("img/rj_glucosa.pdf", width = 5.4, height = 2.7)
source("datos/glucosa.R")
dev.off()
