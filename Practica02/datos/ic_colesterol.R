# poblacion.omv: media del colesterol con su IC 95 % en la muestra pequeña y en la
# grande, y la media real de la población (sin IC: es el parámetro)
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
r <- t(sapply(list(data[data$Muestra_peq == 1, ], data[data$Muestra_grande == 1, ]),
              function(d) c(mean(d$Colesterol), t.test(d$Colesterol)$conf.int)))
real <- mean(data$Colesterol)
op <- par(mar = c(3, 7.5, 1.2, 5.6), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
y <- c(3, 2, 1)
plot(NA, xlim = range(r[, 2:3], real) + c(-2, 2), ylim = c(0.5, 3.5), yaxt = "n", xaxt = "n",
     bty = "l", xlab = "Colesterol (mg/dL)", ylab = "")
axis(1, seq(200, 220, 10))
axis(2, y, c("Muestra pequeña\n(n = 30)", "Muestra grande\n(n = 300)", "Población\n(N = 2000)"),
     las = 1, tick = FALSE, cex.axis = 0.75)
abline(v = real, col = "firebrick", lty = 3)                  # media real de la población
segments(r[, 2], y[1:2], r[, 3], y[1:2], lwd = 2.5, col = "steelblue")
points(r[, 1], y[1:2], pch = 15, cex = 1.1, col = "steelblue")
points(real, y[3], pch = 18, cex = 1.6, col = "firebrick")
mtext(c(sprintf("%.1f-%.1f", r[, 2], r[, 3]), sprintf("μ = %.1f", real)), side = 4,
      at = y, las = 1, line = 0.3, cex = 0.7)
mtext("Media y su IC 95 %", side = 3, line = 0.1, cex = 0.75)
par(op)
