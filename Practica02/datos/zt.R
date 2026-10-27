# Normal tipificada Z frente a la t de Student con 2, 5 y 30 grados de libertad
# (no necesita datos: funciona igual en R y en Rj)
op <- par(mar = c(3, 3, 1.2, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
gl  <- c(2, 5, 30)
col <- c("#E3A33B", "#1E8449", "#6E9FD8")
curve(dnorm(x), -4.5, 4.5, n = 400, lwd = 2.5, las = 1, bty = "l",
      xlab = "Valor del estadístico", ylab = "Densidad")
for (i in seq_along(gl)) curve(dt(x, gl[i]), add = TRUE, n = 400, lwd = 1.6, col = col[i], lty = 2)
abline(v = c(-1, 1) * qnorm(0.975), col = "grey40", lty = 3)
leg <- c("Normal Z", sprintf("t con %d gl:  t(0,975) = %s", gl,
         sub(".", ",", sprintf("%.2f", qt(0.975, gl)), fixed = TRUE)))
legend("topright", leg, col = c("black", col), lwd = c(2.5, 1.6, 1.6, 1.6),
       lty = c(1, 2, 2, 2), bty = "n", cex = 0.7)
mtext("Valor que deja el 2,5 % en cada cola: Z = 1,96", side = 3, line = 0.1, cex = 0.75)
par(op)
