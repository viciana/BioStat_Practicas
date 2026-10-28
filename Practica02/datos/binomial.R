# De la binomial a la normal: nº de caras al lanzar n monedas (p = 0.5)
# No necesita datos: es teoría
op <- par(mfrow = c(1, 4), mar = c(3, 3.2, 2, 0.4), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.85, cex.lab = 0.9, cex.main = 1)
for (n in c(1, 4, 10, 40)) {
  x <- 0:n; p <- dbinom(x, n, 0.5)
  mu <- n / 2; s <- sqrt(n / 4)
  plot(x, p, type = "h", lwd = 1.5, col = "#1F4E9A", las = 1, ylim = c(0, max(p) * 1.1),
       xlab = "Nº de caras", ylab = ifelse(n == 1, "Probabilidad", ""),
       xlim = if (n == 1) c(-0.5, 1.5) else c(0, n),
       main = sprintf("%d moneda%s", n, ifelse(n > 1, "s", "")))
  points(x, p, pch = 19, cex = ifelse(n > 10, 0.6, 1.1), col = "#1F4E9A")
  curve(dnorm(x, mu, s), add = TRUE, lwd = 2, col = "#C0392B", n = 300)
}
par(op)
