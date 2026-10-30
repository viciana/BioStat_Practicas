# ---------------------------------------------------------------------
# 25_rj_ic_dos.R
# Ejecuta datos/ic_dos.R (código R/Rj que se da a los alumnos) con
# datos/poblacion.omv, igual que lo haría Rj, y guarda img/rj_ic_dos.pdf
# y la tabla img/res_ic_dos.tex con los mismos números
# Ejecutar desde Practica02:   Rscript src/25_rj_ic_dos.R
# ---------------------------------------------------------------------
source("src/estilo_jmv.R")                # tabla_tex(), f1(), f2(), f3()
data <- jmvReadWrite::read_omv("datos/poblacion.omv")   # en Rj: 'data'
cairo_pdf("img/rj_ic_dos.pdf", width = 4.9, height = 2.85)
source("datos/ic_dos.R")
dev.off()
tab <- with(tabla, data.frame(Muestra, f1(Media), f1(S), f2(EE),
  sprintf("%s a %s", f1(IC_inf), f1(IC_sup)), ifelse(IC_inf <= mu & mu <= IC_sup, "sí", "no"),
  f2(t), ifelse(p < 0.001, "< .001", f3(p)),
  ifelse(Rechazo_H0, "\\textcolor{BrickRed}{rechazo $H_0$}", "\\textcolor{RoyalBlue}{no rechazo $H_0$}")))
names(tab) <- c("Muestra", "$\\bar{x}$", "$s$", "$EE=s/\\sqrt{n}$", "IC 95\\,\\%",
                sprintf("¿Contiene %s?", f1(mu)), "$t$", "$p$", "Decisión")
tabla_tex(tab, "res_ic_dos.tex", "crrrccrrl")
## Los 30 valores de colesterol de cada muestra, para los recuadros de la diapositiva
for (i in 1:2) writeLines(c(sprintf("\\textbf{Muestra %s} (mg/dL)\\\\[0.5mm]", nom[i]),
  paste(apply(matrix(muestras[, k[i]], ncol = 5, byrow = TRUE), 1, paste, collapse = "\\ "),
        collapse = "\\\\\n")), sprintf("img/res_ic_dos_%s.tex", nom[i]))
