# poblacion.omv: tipificación Z = (x - media)/s de tres variables con unidades distintas
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
vars <- c(Edad = "Edad (años)", PAS_basal = "PAS basal (mmHg)", Colesterol = "Colesterol (mg/dL)")
col <- c("#C0392B", "#1F4E9A", "#E3A33B")
op <- par(mfrow = c(2, 3), mar = c(3, 3.8, 1.5, 0.5), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.8, cex.lab = 0.9)
for (i in 1:3) {                                      # fila 1: variables originales
  x <- data[[names(vars)[i]]]; m <- mean(x); s <- sd(x)
  hist(x, breaks = 25, freq = FALSE, col = adjustcolor(col[i], 0.35), border = "grey40",
       las = 1, main = "", xlab = vars[i], ylab = "Densidad")
  curve(dnorm(x, m, s), add = TRUE, lwd = 2, col = col[i])
  abline(v = m, lty = 2)
  mtext(sprintf("media = %.1f   s = %.1f", m, s), side = 3, line = 0.1, cex = 0.7)
}
for (i in 1:3) {                                      # fila 2: tipificadas (todas N(0,1))
  x <- data[[names(vars)[i]]]; z <- (x - mean(x)) / sd(x)
  hist(z, breaks = 25, freq = FALSE, col = adjustcolor(col[i], 0.35), border = "grey40",
       las = 1, main = "", xlab = paste("Z de", names(vars)[i]), ylab = "Densidad",
       xlim = c(-4, 4))
  curve(dnorm(x), add = TRUE, lwd = 2, col = col[i])
  abline(v = 0, lty = 2)
  mtext("media = 0   s = 1", side = 3, line = 0.1, cex = 0.7)
}
par(op)
