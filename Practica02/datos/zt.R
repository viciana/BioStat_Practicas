# Normal tipificada Z frente a la t de Student con 30, 5 y 2 grados de libertad
# (no necesita datos: funciona igual en R y en Rj)
op <- par(mar = c(3, 3, 0.5, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
gl  <- c(30, 5, 2)                     # de más a menos gl: la t se aleja de la Z
col <- c("#6E9FD8", "#1E8449", "#E3A33B")
curve(dnorm(x), -5.5, 5.5, n = 400, lwd = 2.5, las = 1, bty = "l", ylim = c(0, 0.49),
      xlab = "Valor del estadístico", ylab = "Densidad")
for (i in seq_along(gl)) curve(dt(x, gl[i]), add = TRUE, n = 400, lwd = 1.6, col = col[i], lty = 2)
# líneas en los valores críticos: altura decreciente de la Z a la t con menos gl
# (la Z en ambas colas; las t solo a la derecha, para no pisar las fórmulas)
vc <- c(qnorm(0.975), qt(0.975, gl))
alt <- c(0.30, 0.24, 0.18, 0.12)
segments(c(-vc[1], vc), 0, y1 = c(alt[1], alt), col = c("grey30", "grey30", col),
         lty = 3, lwd = 1.3)
leg <- c(sprintf("Normal Z:  Z(0.975) = %.2f", qnorm(0.975)),
         sprintf("t con %d gl:  t(0.975) = %.2f", gl, qt(0.975, gl)))
legend("topright", leg, col = c("black", col), lwd = c(2.5, 1.6, 1.6, 1.6),
       lty = c(1, 2, 2, 2), bty = "n", cex = 0.7,
       title = "Valor que deja el 2.5 % en cada cola:", title.adj = 0)
# fórmulas, con una etiqueta que explica cada una
text(-5.6, 0.478, "Tipificación:", adj = 0, cex = 0.7, font = 2)
text(-5.6, 0.395, adj = 0, cex = 0.75,
     expression(Z == frac(bar(X) - mu, sigma / sqrt(n)) %~% N(0, 1)))
text(-5.6, 0.315, "Densidad de probabilidad:", adj = 0, cex = 0.7, font = 2)
text(-5.6, 0.265, adj = 0, cex = 0.75,
     expression(varphi(z) == frac(1, sqrt(2 * pi)) ~ e^{-z^2 / 2}))
text(-5.6, 0.15, adj = 0, cex = 0.68,
     expression(f(t) == frac(Gamma(over(nu + 1, 2)), sqrt(nu * pi) ~ Gamma(over(nu, 2))) ~
                  bgroup("(", 1 + frac(t^2, nu), ")")^{-over(nu + 1, 2)}))
text(-5.6, 0.06, adj = 0, cex = 0.6, expression(nu == n - 1 ~ "gl"))
par(op)
