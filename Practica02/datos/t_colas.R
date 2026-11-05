# poblacion.omv: la misma muestra (PAS basal, n = 30, H0: mu = 148, alfa = 0.05)
# con contraste bilateral y unilateral. Cambia dónde se reparte alfa: en dos colas
# (alfa/2 en cada una) o entera en una. El t observado es el mismo.
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- data$PAS_basal[data$Muestra_peq == 1]          # muestra pequeña (n = 30)
mu0 <- 148; alfa <- 0.05
t0 <- unname(t.test(x, mu = mu0)$statistic); gl <- length(x) - 1
col_nr <- "#5B9BD5"; col_p <- "#E8960C"; col_cr <- "#A31515"   # no rechazo / p / crítica
xm <- 3.8; ym <- dt(0, gl)
op <- par(mfrow = c(1, 2), mar = c(1.5, 0.5, 1.15, 0.5), mgp = c(1, 0.2, 0), tcl = -0.15, cex.axis = 0.6)
cola <- function(a, b, col) { u <- seq(a, b, length = 200)
  polygon(c(a, u, b), c(0, dt(u, gl), 0), col = col, border = NA) }
base <- function(titulo) {
  plot(NA, xlim = c(-xm, xm), ylim = c(0, ym * 1.05), axes = FALSE, xlab = "", ylab = "")
  axis(1, at = c(-3, 0, 3), pos = 0, cex.axis = 0.6)
  mtext(titulo, side = 3, line = 0.1, cex = 0.62)
}
## Bilateral: alfa/2 en cada cola
tc <- qt(1 - alfa / 2, gl); p2 <- 2 * pt(-abs(t0), gl)
base(bquote("Bilateral," ~ H[1] * ":" ~ mu != .(mu0) * ":  no se rechaza," ~ p == .(sprintf("%.4f", p2))))
cola(-t0, t0, col_nr)
for (s in c(-1, 1)) { cola(min(s * t0, s * tc), max(s * t0, s * tc), col_p)
                       cola(min(s * tc, s * xm), max(s * tc, s * xm), col_cr) }
curve(dt(x, gl), -xm, xm, n = 300, lwd = 1.4, add = TRUE)
segments(c(-1, 1) * tc, 0, c(-1, 1) * tc, 0.19, col = col_cr, lwd = 1.1)
segments(c(-1, 1) * t0, 0, c(-1, 1) * t0, 0.29, lty = 2, lwd = 1.1)
text(tc, 0.17, bquote(t[alpha/2] == .(sprintf("%.3f", tc))), pos = 4, offset = 0.12, cex = 0.6)
text(-tc, 0.17, bquote(-t[alpha/2]), pos = 2, offset = 0.12, cex = 0.6)
text(t0, 0.28, bquote(t[obs] == .(sprintf("%.2f", t0))), pos = 4, offset = 0.12, cex = 0.6)
text(-t0, 0.28, bquote(-t[obs]), pos = 2, offset = 0.12, cex = 0.6)
text(0, 0.12, "no rechazo", cex = 0.6, font = 2)
text(3.1, 0.07, bquote(alpha/2), cex = 0.6); text(-3.1, 0.07, bquote(alpha/2), cex = 0.6)
## Unilateral: todo alfa en la cola derecha
tc1 <- qt(1 - alfa, gl); p1 <- pt(t0, gl, lower.tail = FALSE)
base(bquote("Unilateral," ~ H[1] * ":" ~ mu > .(mu0) * ":  se rechaza," ~ p == .(sprintf("%.4f", p1))))
cola(-xm, tc1, col_nr); cola(tc1, xm, col_cr)
curve(dt(x, gl), -xm, xm, n = 300, lwd = 1.4, add = TRUE)
segments(tc1, 0, tc1, 0.19, col = col_cr, lwd = 1.1)         # casi coinciden con t_obs:
segments(t0, 0, t0, 0.29, lty = 2, lwd = 1.1)                # etiquetas a distinta altura
text(t0, 0.17, bquote(t[alpha] == .(sprintf("%.3f", tc1))), pos = 4, offset = 0.12, cex = 0.6)
text(t0, 0.28, bquote(t[obs] == .(sprintf("%.3f", t0))), pos = 4, offset = 0.12, cex = 0.6)
text(-0.25, 0.12, "no rechazo", cex = 0.6, font = 2)
text(3.1, 0.07, bquote(alpha), cex = 0.6)
par(op)
