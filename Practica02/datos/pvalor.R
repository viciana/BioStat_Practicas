# poblacion.omv: contraste de conformidad para la PAS basal, H0: mu = 148, alfa = 0.05.
# Sobre la t de Student: región de no rechazo, región crítica y p-valor.
# Las dos bandas de abajo muestran que son cosas distintas: la región crítica la fija
# alfa (antes de ver los datos) y la zona del p-valor la fija t_obs (la muestra).
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- data$PAS_basal[data$Muestra_peq == 1]          # muestra pequeña (n = 30)
mu0 <- 148; alfa <- 0.05                              # H0: mu = 148 mmHg
tt <- t.test(x, mu = mu0); t0 <- abs(unname(tt$statistic)); gl <- unname(tt$parameter)
tc <- qt(1 - alfa / 2, gl)
col_nr <- "#5B9BD5"; col_p <- "#E8960C"; col_cr <- "#A31515"   # no rechazo / p / crítica
xm <- 3.8; ym <- dt(0, gl)
op <- par(mar = c(2.1, 0.4, 1.1, 0.4), mgp = c(1.1, 0.25, 0), tcl = -0.2, cex.axis = 0.62, cex.lab = 0.72)
plot(NA, xlim = c(-xm, xm), ylim = c(-0.135, ym * 1.12), axes = FALSE, xlab = "t (si H0 fuera cierta)", ylab = "")
cola <- function(a, b, col) { u <- seq(a, b, length = 200)
  polygon(c(a, u, b), c(0, dt(u, gl), 0), col = col, border = NA) }
cola(-t0, t0, col_nr)                                 # centro: no rechazo
for (s in c(-1, 1)) {
  cola(min(s * t0, s * tc), max(s * t0, s * tc), col_p)   # entre t_obs y t_alfa/2: p, sin rechazo
  cola(min(s * tc, s * xm), max(s * tc, s * xm), col_cr)  # cola: crítica (y también p)
}
curve(dt(x, gl), -xm, xm, n = 400, lwd = 1.6, add = TRUE)
axis(1, at = c(-3, 0, 3), pos = -0.135, cex.axis = 0.62)
## Bandas: qué decide alfa y qué decide la muestra
banda <- function(a, b, y, col) rect(a, y - 0.013, b, y + 0.013, col = col, border = "white", lwd = 0.8)
banda(-tc, tc, -0.05, col_nr); banda(-xm, -tc, -0.05, col_cr); banda(tc, xm, -0.05, col_cr)
banda(-xm, -t0, -0.09, col_p); banda(t0, xm, -0.09, col_p)
text(0, -0.05, "región de no rechazo", cex = 0.55)
text(c(-1, 1) * (tc + xm) / 2, -0.05, "crítica", cex = 0.55, col = "white", font = 2)
text(c(-1, 1) * (t0 + xm) / 2, -0.09, "zona de p", cex = 0.55, font = 2)
## Valores críticos y t observado
segments(c(-1, 1) * tc, -0.037, c(-1, 1) * tc, 0.215, col = col_cr, lwd = 1.2)
segments(c(-1, 1) * t0, -0.077, c(-1, 1) * t0, 0.30, lty = 2, lwd = 1.2)
text(tc, 0.20, bquote(t[alpha/2] == .(sprintf("%.3f", tc))), pos = 4, offset = 0.15, cex = 0.62)
text(-tc, 0.20, bquote(-t[alpha/2]), pos = 2, offset = 0.15, cex = 0.62)
text(t0, 0.29, bquote(t[obs] == .(sprintf("%.2f", t0))), pos = 4, offset = 0.15, cex = 0.62)
text(-t0, 0.29, bquote(-t[obs]), pos = 2, offset = 0.15, cex = 0.62)
## Áreas (con flecha: las colas son estrechas)
arrows(3.15, 0.115, 2.75, 0.008, length = 0.04, lwd = 0.8)
text(3.15, 0.135, bquote(alpha/2 == .(alfa / 2)), cex = 0.6)
text(0, 0.14, bquote(1 - alpha == .(1 - alfa)), cex = 0.68, font = 2)
arrows(-3.05, 0.09, -1.87, 0.03, length = 0.04, lwd = 0.8)
text(-3.05, 0.11, bquote(p/2 == .(sprintf("%.3f", tt$p.value / 2))), cex = 0.6)
text(-3.05, 0.14, "ámbar + rojo:", cex = 0.55)
mtext(bquote(H[0] * ":" ~ mu == .(mu0) * "," ~~ alpha == .(alfa) * "," ~~ gl == .(gl) * "," ~~
             p == .(sprintf("%.3f", tt$p.value))), side = 3, line = 0.05, cex = 0.62)
par(op)
