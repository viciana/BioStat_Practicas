# La curva normal: media, desviación típica, puntos de inflexión y áreas
# No necesita datos: es teoría (aquí mu = 0 y sigma = 1; para otra N(mu, sigma) basta reescalar)
mu <- 0; s <- 1
op <- par(mar = c(3.4, 3.4, 0.8, 0.5), mgp = c(2, 0.6, 0), cex.axis = 0.75, cex.lab = 0.9)
x <- seq(mu - 4 * s, mu + 4 * s, length.out = 600)
plot(x, dnorm(x, mu, s), type = "n", las = 1, bty = "l", xaxt = "n",
     xlab = "", ylab = "Densidad f(x)", ylim = c(0, 0.46))
bandas <- list(c(3, "#F3E3C3"), c(2, "#EDC77F"), c(1, "#E3A33B"))   # ±3, ±2, ±1 sigma
for (b in bandas) {
  k <- as.numeric(b[1]); z <- seq(mu - k * s, mu + k * s, length.out = 200)
  polygon(c(z, rev(z)), c(dnorm(z, mu, s), rep(0, 200)), col = b[2], border = NA)
}
dentro <- abs(x - mu) <= s                         # cóncava (f'' < 0) entre mu - s y mu + s
lines(x[dentro], dnorm(x[dentro], mu, s), lwd = 3, col = "#1F4E9A")
lines(x[x <= mu - s], dnorm(x[x <= mu - s], mu, s), lwd = 3, col = "#1E8449")   # convexa (f'' > 0)
lines(x[x >= mu + s], dnorm(x[x >= mu + s], mu, s), lwd = 3, col = "#1E8449")
for (k in c(-1, 1)) {                                 # tangente en el punto de inflexión: cruza la curva
  y0 <- dnorm(mu + k * s, mu, s); m <- -dnorm(mu + k * s, mu, s) * k / s
  xt <- mu + k * s + c(-1.1, 1.1) * s
  segments(xt[1], y0 + m * (xt[1] - mu - k * s), xt[2], y0 + m * (xt[2] - mu - k * s),
           col = "#C0392B", lwd = 1.2)
}
abline(v = mu, lty = 2)
segments(mu + c(-1, 1) * s, 0, mu + c(-1, 1) * s, dnorm(1, mu, s), lty = 3)
points(mu + c(-1, 1) * s, rep(dnorm(1, mu, s), 2), pch = 21, bg = "white", col = "#C0392B", lwd = 2, cex = 1.3)
text(mu + 1.05 * s, dnorm(1, mu, s) + 0.07, "punto de\ninflexión", adj = 0, cex = 0.7, col = "#C0392B")
text(mu - 1.05 * s, dnorm(1, mu, s) + 0.07, "punto de\ninflexión", adj = 1, cex = 0.7, col = "#C0392B")
axis(1, at = mu + (-3:3) * s,
     labels = expression(mu - 3 * sigma, mu - 2 * sigma, mu - sigma, mu, mu + sigma, mu + 2 * sigma, mu + 3 * sigma))
text(mu, 0.14, "68.3 %", font = 2, cex = 0.9)
text(mu, 0.27, "cóncava\n(f'' < 0)", cex = 0.7, col = "#1F4E9A")
text(mu - 2.9 * s, 0.12, "convexa\n(f'' > 0)", cex = 0.7, col = "#1E8449")
text(mu + 2.9 * s, 0.12, "convexa\n(f'' > 0)", cex = 0.7, col = "#1E8449")
text(mu + 1.5 * s, 0.07, "95.4 %", cex = 0.7); text(mu - 1.5 * s, 0.07, "95.4 %", cex = 0.7)
text(mu + 2.5 * s, 0.03, "99.7 %", cex = 0.65); text(mu - 2.5 * s, 0.03, "99.7 %", cex = 0.65)
par(op)
