# poblacion.omv: ley de los grandes números con el colesterol.
# Seis «investigadores» van añadiendo pacientes al azar (n = 1, 2, ..., 1000) y
# recalculan la media: todas las trayectorias acaban pegadas a mu.
# La franja gris es mu ± 1.96 sigma / sqrt(n): por donde cae el 95 % de las medias.
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- data$Colesterol; mu <- mean(x); sigma <- sd(x)
nmax <- 1000; n <- 1:nmax
set.seed(3)
tray <- replicate(6, cumsum(sample(x, nmax, replace = TRUE)) / n)   # media acumulada
col <- hcl.colors(6, "Dark 3")
op <- par(mar = c(3, 3.6, 0.6, 0.6), mgp = c(1.9, 0.6, 0), cex.axis = 0.75, cex.lab = 0.85)
plot(NA, xlim = c(1, nmax), ylim = mu + c(-45, 45), log = "x", las = 1, bty = "l",
     xlab = "Tamaño de la muestra n (escala logarítmica)", ylab = "Media muestral (mg/dL)")
polygon(c(n, rev(n)), c(mu + 1.96 * sigma / sqrt(n), rev(mu - 1.96 * sigma / sqrt(n))),
        col = adjustcolor("grey60", 0.35), border = NA)
matlines(n, tray, lty = 1, lwd = 1.2, col = col)
abline(h = mu, lty = 2)
text(1.2, mu + 3, bquote(mu == .(sprintf("%.1f", mu))), adj = c(0, 0), cex = 0.75)
text(60, mu + 1.96 * sigma / sqrt(60) + 4, expression(mu %+-% 1.96 ~ sigma / sqrt(n)),
     adj = c(0, 0), cex = 0.7, col = "grey30")
abline(v = 30, lty = 3, col = "grey40")
text(30, mu - 44, "n = 30", pos = 4, cex = 0.65, col = "grey30")
par(op)
