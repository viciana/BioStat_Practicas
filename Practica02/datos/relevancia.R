# poblacion.omv: significación estadística frente a relevancia clínica.
# Diferencia de PAS a las 8 semanas (Placebo - Suplemento) con su IC 95 %,
# frente a una franja de diferencias clínicamente irrelevantes (< 5 mmHg).
# Las dos primeras filas salen de los datos; las dos últimas son ensayos
# HIPOTÉTICOS (diferencia e IC calculados con la DE de la PAS, ~16 mmHg).
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
dif <- function(d) { tt <- t.test(d$PAS_8sem[d$Tratamiento == "Placebo"],   # t de Student,
                                  d$PAS_8sem[d$Tratamiento == "Suplemento"],   # como en jamovi
                                  var.equal = TRUE)
  c(unname(tt$estimate[1] - tt$estimate[2]), tt$conf.int) }
hipo <- function(d, n, de = sd(data$PAS_8sem)) {           # IC con n por grupo
  ee <- de * sqrt(2 / n); c(d, d + c(-1, 1) * qt(0.975, 2 * n - 2) * ee) }
r <- rbind(dif(data[data$Muestra_grande == 1, ]),
           dif(data[data$Muestra_peq == 1, ]),
           hipo(1.5, 20000),
           hipo(0.3, 3000))
etiq <- c("Muestra grande\n(n = 300)", "Muestra pequeña\n(n = 30)",
          "Hipotético\n(n = 40 000)", "Hipotético\n(n = 6000)")
juicio <- c("significativo\ny relevante", "no concluyente",
            "significativo pero\nirrelevante", "no significativo:\nsin efecto relevante")
mcd <- 5                                                   # mínima diferencia relevante
y <- 4:1
op <- par(mar = c(3, 6.8, 0.6, 7), mgp = c(1.8, 0.6, 0), cex.axis = 0.75, cex.lab = 0.8)
plot(NA, xlim = c(-6, 17), ylim = c(0.6, 4.8), yaxt = "n", bty = "l",
     xlab = "Diferencia de PAS, Placebo - Suplemento (mmHg)", ylab = "")
rect(-mcd, 0, mcd, 5, col = adjustcolor("grey70", 0.35), border = NA)
text(0, 4.62, "irrelevante (< 5 mmHg)", cex = 0.6, col = "grey30")
segments(0, 0.6, 0, 4.45, lty = 2, col = "grey40")         # «sin efecto»
axis(2, y, etiq, las = 1, tick = FALSE, cex.axis = 0.7)
col <- c("steelblue", "steelblue", "grey45", "grey45")
segments(r[, 2], y, r[, 3], y, lwd = 2.5, col = col)
points(r[, 1], y, pch = 15, cex = 1, col = col)
mtext(juicio, side = 4, at = y, las = 1, line = 0.3, cex = 0.6)
par(op)
