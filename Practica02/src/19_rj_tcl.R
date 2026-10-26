# ---------------------------------------------------------------------
# 19_rj_tcl.R
# Ejecuta datos/tcl.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_tcl.pdf
# Ejecutar desde Practica02:   Rscript src/19_rj_tcl.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_tcl.pdf", width = 9.5, height = 6)
source("datos/tcl.R")
dev.off()
