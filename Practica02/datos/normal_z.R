# De cualquier normal N(mu, sigma) a la Z = N(0, 1): una cuadrícula 4 x 4.
# Las 12 casillas del borde son normales con distintas mu y sigma, todas en la
# misma escala (área = 1 en todas: si sigma crece, la campana se aplana);
# las 4 del centro, la Z, con sus puntos de inflexión y áreas.
# No necesita datos: es teoría
casillas <- data.frame(                            # en orden: fila 1, laterales, fila 4
  mu    = c(-1,  0,   1,   2,  -1, 1,   0, 2,  -1,  0, 1, 2),
  sigma = c(0.5, 0.5, 0.5, 0.5, 1, 1,   1, 1,   2,  2, 2, 2))
fila <- c(1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4); colu <- c(1:4, 1, 4, 1, 4, 1:4)
xr <- c(-7, 8);   yr <- c(0, 0.95)                  # escala común a las 12 casillas
pal <- hcl.colors(3, "Dark 3")                      # un color por cada sigma
op <- par(no.readonly = TRUE)
layout(matrix(c(1, 2, 3, 4, 5, 13, 13, 6, 7, 13, 13, 8, 9, 10, 11, 12), 4, byrow = TRUE))
par(oma = c(0, 0, 0.4, 0), mgp = c(1, 0.1, 0), tcl = -0.15)

## Las 12 normales del borde
for (i in 1:12) {
  m <- casillas$mu[i]; s <- casillas$sigma[i]; cl <- pal[match(s, c(0.5, 1, 2))]
  par(mar = c(2.0, 0.4, 0.2, 0.4))
  x <- seq(xr[1], xr[2], length.out = 500)
  plot(x, dnorm(x, m, s), type = "n", xlim = xr, ylim = yr, bty = "n",
       xaxt = "n", yaxt = "n", xlab = "", ylab = "")
  polygon(c(x, rev(x)), c(dnorm(x, m, s), rep(0, 500)), col = adjustcolor(cl, 0.25), border = NA)
  lines(x, dnorm(x, m, s), lwd = 1.3, col = cl)
  segments(m, 0, m, dnorm(m, m, s), lty = 2, col = "grey40")
  points(m + c(-1, 1) * s, dnorm(m + c(-1, 1) * s, m, s), pch = 21, bg = "white", col = cl, cex = 0.6)
  axis(1, at = seq(-6, 6, 3), cex.axis = 0.5, lwd = 0.6)
  mtext(bquote(N(mu == .(m) * "," ~ sigma == .(s))), side = 1, line = 1.05, cex = 0.5, col = cl)
}

## El centro: la Z, como en la diapositiva de la curva normal
par(mar = c(1.6, 1.6, 0.4, 1.6))
z <- seq(-4, 4, length.out = 600)
plot(z, dnorm(z), type = "n", xlim = c(-4, 4), ylim = c(0, 0.48), bty = "n",
     xaxt = "n", yaxt = "n", xlab = "", ylab = "")
for (b in list(c(3, "#F3E3C3"), c(2, "#EDC77F"), c(1, "#E3A33B"))) {   # ±3, ±2, ±1
  k <- as.numeric(b[1]); u <- seq(-k, k, length.out = 200)
  polygon(c(u, rev(u)), c(dnorm(u), rep(0, 200)), col = b[2], border = NA)
}
lines(z, dnorm(z), lwd = 2.5, col = "firebrick")
segments(0, 0, 0, dnorm(0), lty = 2)
points(c(-1, 1), rep(dnorm(1), 2), pch = 21, bg = "white", col = "firebrick", lwd = 1.5, cex = 1.1)
text(-1.2, dnorm(1) + 0.03, "punto de\ninflexión", adj = c(1, 0), cex = 0.55, col = "firebrick")
text(1.2, dnorm(1) + 0.03, "punto de\ninflexión", adj = c(0, 0), cex = 0.55, col = "firebrick")
axis(1, at = -3:3, cex.axis = 0.7, mgp = c(1, 0.3, 0), lwd = 0.8)
text(0, 0.13, "68.3 %", font = 2, cex = 0.8)
text(c(-1.5, 1.5), 0.05, "95.4 %", cex = 0.6); text(c(-2.5, 2.5), 0.02, "99.7 %", cex = 0.55)
tz <- expression(bold(Z %~% N(0 * "," ~ 1)) * ":" ~ mu == 0 * "," ~ sigma == 1)
rect(-strwidth(tz, cex = 0.75) / 2 - 0.1, 0.44, strwidth(tz, cex = 0.75) / 2 + 0.1, 0.49,
     col = "white", border = NA)
text(0, 0.465, expression(bold(Z %~% N(0 * "," ~ 1)) * ":" ~ mu == 0 * "," ~ sigma == 1),
     cex = 0.75, col = "firebrick")                 # entre las dos flechas de arriba
text(3.3, 0.13, "área = 1", cex = 0.65)

## Flechas de cada casilla hacia la Z (coordenadas de toda la figura, 0-1)
par(fig = c(0, 1, 0, 1), mar = c(0, 0, 0, 0), new = TRUE)
plot.new(); plot.window(c(0, 1), c(0, 1), xaxs = "i", yaxs = "i")
cx <- (colu - 0.5) / 4; cy <- 1 - (fila - 0.5) / 4             # centro de cada casilla
x0 <- pmin(pmax(cx, 0.21), 0.79); y0 <- pmin(pmax(cy, 0.21), 0.745) # borde interior (bajo el título)
x1 <- pmin(pmax(cx, 0.28), 0.72); y1 <- pmin(pmax(cy, 0.28), 0.69)  # borde de la Z
arrows(x0, y0, x1, y1, length = 0.05, col = "grey45", lwd = 1)
par(op)
