# poblacion.omv: diferencia de PAS a las 8 semanas (Placebo - Fármaco) con su IC 95 %
# en la muestra pequeña, la grande y la población (valor real, sin IC)
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
dif <- function(d) { tt <- t.test(d$PAS_8sem[d$Tratamiento == "Placebo"],   # t de Student,
                                  d$PAS_8sem[d$Tratamiento == "Fármaco"],   # como en jamovi
                                  var.equal = TRUE)
  c(unname(tt$estimate[1] - tt$estimate[2]), tt$conf.int, tt$p.value) }
r <- rbind(pequeña = dif(data[data$Muestra_peq == 1, ]),
           grande  = dif(data[data$Muestra_grande == 1, ]))
real <- with(data, mean(PAS_8sem[Tratamiento == "Placebo"]) -
                   mean(PAS_8sem[Tratamiento == "Fármaco"]))
op <- par(mar = c(3, 7.5, 1.2, 4.2), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
y <- c(3, 2, 1)
plot(NA, xlim = range(0, r[, 2:3], real) + c(-1, 1), ylim = c(0.5, 3.5), yaxt = "n",
     bty = "l", xlab = "Diferencia de PAS, Placebo - Fármaco (mmHg)", ylab = "")
axis(2, y, c("Muestra pequeña\n(n = 30)", "Muestra grande\n(n = 300)", "Población\n(N = 2000)"),
     las = 1, tick = FALSE, cex.axis = 0.75)
abline(v = 0, lty = 2, col = "grey40")                        # «sin efecto»
abline(v = real, col = "firebrick", lty = 3)
segments(r[, 2], y[1:2], r[, 3], y[1:2], lwd = 2.5, col = "steelblue")
points(r[, 1], y[1:2], pch = 15, cex = 1.1, col = "steelblue")
points(real, y[3], pch = 18, cex = 1.6, col = "firebrick")
mtext(c(ifelse(r[, 4] < 0.001, "p < 0.001", sprintf("p = %.3f", r[, 4])), "valor real"), side = 4, at = y, las = 1,
      line = 0.3, cex = 0.7)
mtext("El IC que contiene el 0 no permite rechazar H0", side = 3, line = 0.1, cex = 0.75)
par(op)
