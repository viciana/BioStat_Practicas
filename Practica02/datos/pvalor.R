# poblacion.omv: el p-valor de una t para una muestra, dibujado sobre la t de Student
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- data$PAS_basal[data$Muestra_peq == 1]          # muestra pequeña (n = 30)
mu0 <- 148                                            # H0: mu = 148 mmHg
tt <- t.test(x, mu = mu0); t0 <- unname(tt$statistic); gl <- unname(tt$parameter)
op <- par(mar = c(3, 3, 1.2, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
curve(dt(x, gl), -4.5, 4.5, n = 400, lwd = 2, las = 1, bty = "l",
      xlab = "t (si H0 fuera cierta)", ylab = "Densidad")
cola <- function(a, b, col) { u <- seq(a, b, length = 200)
  polygon(c(a, u, b), c(0, dt(u, gl), 0), col = col, border = NA) }
tc <- qt(0.975, gl)
cola(-4.5, -tc, "#F5B7B1"); cola(tc, 4.5, "#F5B7B1")      # región de rechazo (alfa)
cola(abs(t0), 4.5, "#C0392B80"); cola(-4.5, -abs(t0), "#C0392B80")  # p-valor
abline(v = t0, col = "steelblue", lwd = 2)
text(t0, dt(0, gl) * 0.55, sprintf("t = %.2f", t0), pos = ifelse(t0 > 0, 4, 2),
     col = "steelblue", cex = 0.8)
mtext(sprintf("H0: mu = %d   p = %.3f   (alfa = 0.05)", mu0, tt$p.value),
      side = 3, line = 0.1, cex = 0.8)
par(op)
