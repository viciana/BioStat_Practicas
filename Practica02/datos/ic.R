# poblacion.omv: 100 muestras de n = 30 y su IC 95 % para la media del colesterol.
# Abajo, el mismo experimento visto como contraste de H0: mu = media poblacional:
# el estadístico t de cada muestra sobre su distribución bajo H0 (t con n - 1 gl).
# Un IC que no contiene a mu  <=>  su t cae en la región crítica (|t| > t(0.975)).
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
mu <- mean(data$Colesterol)                         # media poblacional (conocida)
set.seed(7);  # semilla aleatoria, marcar para nuevas muestras 
n <- 30
muestras <- replicate(100, sample(data$Colesterol, n))          # una columna por muestra
ic <- t(apply(muestras, 2, \(x) t.test(x)$conf.int))
falla <- ic[, 1] > mu | ic[, 2] < mu                  # IC que no atrapan a mu
tt <- apply(muestras, 2, \(x) (mean(x) - mu) / (sd(x) / sqrt(n)))   # t bajo H0
tc <- qt(0.975, n - 1)                                # valor crítico
ee <- sd(data$Colesterol) / sqrt(n)                   # escala: t -> mg/dL (alineado)
x_t <- function(t) mu + t * ee
xl <- range(ic, x_t(c(-1, 1) * max(abs(tt), 4)))
col <- ifelse(falla, "firebrick", "steelblue")

op <- par(no.readonly = TRUE)
layout(matrix(1:2), heights = c(3, 1.5))
par(mar = c(0.6, 3, 2.3, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
plot(NA, xlim = xl, ylim = c(1, 100), las = 1, bty = "l", xaxt = "n",
     xlab = "", ylab = "Muestra nº")
axis(3, cex.axis = 0.7, mgp = c(1.8, 0.3, 0), tcl = -0.25)   # mg/dL arriba
segments(ic[, 1], 1:100, ic[, 2], 1:100, lwd = 1.4, col = col)
points(rowMeans(ic), 1:100, pch = 20, cex = 0.4)
abline(v = mu, lty = 2)
mtext("Colesterol (mg/dL)", side = 3, line = 1.2, cex = 0.65, adj = 1)
mtext(bquote(.(sum(falla)) ~ "de 100 IC no contienen a" ~ mu == .(format(round(mu, 1), nsmall = 1))),
      side = 3, line = 1.2, cex = 0.7, col = "firebrick", adj = 0)

## Distribución del estadístico bajo H0 (t con n - 1 gl), alineada con el panel de arriba
par(mar = c(3, 3, 0.3, 0.5))
tg <- seq(-6, 6, length = 600)
plot(x_t(tg), dt(tg, n - 1), type = "n", xlim = xl, ylim = c(0, 0.42), las = 1,
     bty = "l", xaxt = "n", yaxt = "n", xlab = bquote("Estadístico" ~ t ~ "bajo" ~ H[0] ~
     "(" * .(n - 1) ~ "gl)"), ylab = "")
for (s in c(-1, 1)) {                                 # región crítica (rojo)
  u <- tg[s * tg >= tc]
  polygon(x_t(c(s * tc, u, s * tc)), c(0, dt(u, n - 1), 0),
          col = adjustcolor("firebrick", 0.35), border = NA)
}
lines(x_t(tg), dt(tg, n - 1), lwd = 1.5)
abline(v = mu, lty = 2)
axis(1, at = x_t(-4:4), labels = -4:4)
alt <- runif(100, 0.04, 0.9) * dt(tt, n - 1)          # ruido vertical bajo la curva
points(x_t(tt), alt, pch = 19, cex = 0.55, col = adjustcolor(col, 0.8))
text(x_t(c(-1, 1) * (tc + 0.9)), 0.3, sprintf("|t| > %.2f", tc), cex = 0.6, col = "firebrick")
text(x_t(c(-1, 1) * (tc + 0.9)), 0.22, "región crítica\n(2.5 %)", cex = 0.55, col = "firebrick")
par(op)
