# ---------------------------------------------------------------------
# 28_rj_tcl_ee.R
# Ejecuta datos/tcl_ee.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_tcl_ee.pdf
# Ejecutar desde Practica02:   Rscript src/28_rj_tcl_ee.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_tcl_ee.pdf", width = 4.2, height = 3.6)
source("datos/tcl_ee.R")
dev.off()
