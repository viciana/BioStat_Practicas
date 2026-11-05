# La distribución chi-cuadrado y su región crítica (alfa = 0.05) para las tablas de la
# práctica: 2x2 (gl = 1), 3x2 (gl = 2) y 4x2 (gl = 3). Es asimétrica y solo se rechaza
# por la derecha: valores grandes = observadas lejos de las esperadas.
# Prueba a cambiar 'gls' o 'alfa'. No necesita datos: funciona igual en R y en Rj (JAMOVI).
gls <- c(1, 2, 3); tablas <- c("2 x 2", "3 x 2", "4 x 2"); alfa <- 0.05
col_nr <- "#5B9BD5"; col_cr <- "#A31515"              # no rechazo / crítica
xm <- 12; ym <- 0.45
op <- par(mfrow = c(1, 3), mar = c(1.9, 0.5, 1.6, 0.5), mgp = c(1, 0.25, 0), tcl = -0.15)
for (i in seq_along(gls)) {
  g <- gls[i]; ch <- qchisq(1 - alfa, g)
  d <- function(u) pmin(dchisq(u, g), ym)             # gl = 1 tiende a infinito en 0
  plot(NA, xlim = c(0, xm), ylim = c(0, ym), axes = FALSE, xlab = "", ylab = "")
  axis(1, at = seq(0, 12, 4), pos = 0, cex.axis = 0.85)
  u <- seq(0.001, ch, length = 300); polygon(c(0, u, ch), c(0, d(u), 0), col = col_nr, border = NA)
  u <- seq(ch, xm, length = 200);    polygon(c(ch, u, xm), c(0, d(u), 0), col = col_cr, border = NA)
  curve(d(x), 0.001, xm, n = 400, lwd = 1.4, add = TRUE)
  segments(ch, 0, ch, 0.2, col = col_cr, lwd = 1.1)
  text(ch, 0.235, sprintf("%.2f", ch), cex = 1.05, font = 2)
  text(xm, c(0.15, 0.09), c("región crítica", as.expression(bquote(alpha == .(alfa)))), adj = 1, cex = 0.95)
  mtext(bquote(gl == .(g) ~ "(tabla" ~ .(tablas[i]) * ")"), side = 3, line = 0.1, cex = 0.62)
}
par(op)
