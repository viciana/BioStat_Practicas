# poblacion.omv: 100 muestras de n = 30 y su IC 95 % para la media del colesterol
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
mu <- mean(data$Colesterol)                         # media poblacional (conocida)
set.seed(7); n <- 30
ic <- t(replicate(100, t.test(sample(data$Colesterol, n))$conf.int))
falla <- ic[, 1] > mu | ic[, 2] < mu                  # IC que no atrapan a mu
op <- par(mar = c(3, 3, 1.2, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
plot(NA, xlim = range(ic), ylim = c(1, 100), las = 1, bty = "l",
     xlab = "Colesterol (mg/dL)", ylab = "Muestra nº")
segments(ic[, 1], 1:100, ic[, 2], 1:100, lwd = 1.4,
         col = ifelse(falla, "firebrick", "steelblue"))
points(rowMeans(ic), 1:100, pch = 20, cex = 0.4)
abline(v = mu, lty = 2)
mtext(bquote(.(sum(falla)) ~ "de 100 IC no contienen a" ~ mu == .(format(round(mu, 1), nsmall = 1))),
      side = 3, line = 0.1, cex = 0.8, col = "firebrick")
par(op)
