# poblacion.omv: teorema central del límite con una variable MUY asimétrica (PCR).
# Arriba: la PCR en la población (N = 2000). Abajo, en la misma escala: las medias
# de 5000 muestras de n = 30. Aunque la PCR no es normal, sus medias sí (casi):
# se agrupan alrededor de mu con desviación típica EE = sigma / sqrt(n).
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- data$PCR; mu <- mean(x); sigma <- sd(x); n <- 30; ee <- sigma / sqrt(n)
set.seed(5)
medias <- replicate(5000, mean(sample(x, n)))
xl <- c(0, 16)
op <- par(mfrow = c(2, 1), mar = c(2.6, 3.6, 1.3, 0.6), mgp = c(1.7, 0.5, 0),
          cex.axis = 0.75, cex.lab = 0.8, cex.main = 0.85)
hist(x[x <= xl[2]], breaks = seq(0, xl[2], 0.5), freq = FALSE, col = "#A8C6EE", border = "grey40",
     las = 1, xlim = xl, main = "Población: PCR (mg/L), muy asimétrica", xlab = "", ylab = "Densidad")
abline(v = mu, lty = 2, lwd = 1.5)
text(mu, par("usr")[4] * 0.85, bquote(mu == .(sprintf("%.2f", mu)) ~ ", " ~ sigma == .(sprintf("%.2f", sigma))),
     pos = 4, cex = 0.75)
hist(medias, breaks = seq(0, xl[2], 0.1), freq = FALSE, col = "#EDC77F", border = "grey55",
     las = 1, xlim = xl, main = bquote(bold("Medias de 5000 muestras de" ~ n == .(n))), xlab = "PCR (mg/L)",
     ylab = "Densidad")
u <- seq(xl[1], xl[2], length.out = 600)
lines(u, dnorm(u, mu, ee), lwd = 2, col = "firebrick")
abline(v = mu, lty = 2, lwd = 1.5)
text(mu + 1.4, max(dnorm(u, mu, ee)) * 0.7, adj = 0, cex = 0.75, col = "firebrick",
     bquote(N(mu * "," ~ EE) ~ ":" ~ EE == sigma / sqrt(n) * " = " * .(sprintf("%.2f", ee))))
text(mu + 1.4, max(dnorm(u, mu, ee)) * 0.4, adj = 0, cex = 0.7,
     bquote("media de las medias" == .(sprintf("%.2f", mean(medias))) ~ "" %~~% mu))
par(op)
