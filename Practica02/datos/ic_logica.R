# poblacion.omv: de la distribución de las medias al intervalo de confianza.
# Arriba: por el TCL, las medias de n = 30 se reparten como N(mu, EE); el 95 % cae
# en mu ± 1.96 EE. Abajo: seis de las 100 muestras de ic.R (A y B las de ic_dos.R)
# con su intervalo x̄ ± 1.96 EE. Si x̄ está a menos de 1.96 EE de mu, mu está a
# menos de 1.96 EE de x̄: el intervalo atrapa a mu (azul). Si no, falla (rojo).
# Para simplificar, aquí sigma es conocida (Z, 1.96); con S se usa la t (2.045).
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
mu <- mean(data$Colesterol); n <- 30; ee <- sd(data$Colesterol) / sqrt(n)
set.seed(7)                                          # las mismas 100 muestras que ic.R
muestras <- replicate(100, sample(data$Colesterol, n))
k   <- c(19, 23, 18, 28, 68, 77)                     # seis muestras de ejemplo
nom <- c("19", "A", "18", "28", "68", "B")
m   <- colMeans(muestras[, k]); li <- m - 1.96 * ee; ls <- m + 1.96 * ee
col <- ifelse(li > mu | ls < mu, "firebrick", "steelblue")
xl  <- mu + c(-3.8, 4.6) * ee                      # que quepa el IC de B
op <- par(mfrow = c(2, 1), mar = c(1.2, 3.8, 0.4, 5.2), mgp = c(1.8, 0.5, 0), cex.axis = 0.75)
layout(matrix(1:2), heights = c(1.15, 1))
## Arriba: distribución de las medias muestrales (TCL)
u <- seq(xl[1], xl[2], length.out = 600)
plot(u, dnorm(u, mu, ee), type = "n", xlim = xl, ylim = c(0, 1.12 * dnorm(0) / ee), bty = "n",
     las = 1, yaxt = "n", xlab = "", ylab = "")
c95 <- u[abs(u - mu) <= 1.96 * ee]
polygon(c(c95, rev(c95)), c(dnorm(c95, mu, ee), rep(0, length(c95))),
        col = adjustcolor("steelblue", 0.25), border = NA)
lines(u, dnorm(u, mu, ee), lwd = 2)
segments(mu, 0, mu, 1.12 * dnorm(0) / ee, lty = 2)
text(mu, 1.08 * dnorm(0) / ee, bquote(mu == .(sprintf("%.1f", mu))), pos = 4, cex = 0.7)
y95 <- 0.25 * dnorm(0) / ee
arrows(mu - 1.96 * ee, y95, mu + 1.96 * ee, y95, code = 3, length = 0.05, col = "steelblue4")
text(mu, y95, expression("95 %:" ~ mu %+-% 1.96 ~ EE), pos = 3, cex = 0.7, col = "steelblue4")
text(xl[1], 0.95 * dnorm(0) / ee, expression(bar(X) %~~% N(mu * "," ~ EE)), adj = 0, cex = 0.75)
text(xl[1], 0.78 * dnorm(0) / ee, bquote(EE == sigma / sqrt(n) * " = " * .(sprintf("%.2f", ee))),
     adj = 0, cex = 0.7)
points(m, rep(0, 6), pch = 19, col = col, cex = 0.9, xpd = NA)
## Abajo: el intervalo de cada muestra, x̄ ± 1.96 EE
par(mar = c(2.8, 3.8, 0.2, 5.2))
y <- 6:1
plot(NA, xlim = xl, ylim = c(0.5, 6.6), bty = "l", yaxt = "n", xlab = "Colesterol (mg/dL)",
     ylab = "")
axis(2, y, paste("muestra", nom), las = 1, tick = FALSE, cex.axis = 0.65)
segments(m, 6.6, m, y, lty = 3, col = col)                        # cada x̄ baja a su fila
abline(v = mu, lty = 2)
segments(li, y, ls, y, lwd = 3, col = col)
points(m, y, pch = 19, cex = 0.8)
text(par("usr")[2], y, sprintf("[%.1f, %.1f]", li, ls), pos = 4, cex = 0.6, col = col, xpd = NA)
text(par("usr")[2], 6.6, expression(bar(x) %+-% 1.96 ~ EE), pos = 4, cex = 0.6, xpd = NA)
par(op)
