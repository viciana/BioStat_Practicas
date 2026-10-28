# poblacion.omv: PAS basal y a las 8 semanas en los mismos pacientes (muestra pequeña)
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
d <- data[data$Muestra_peq == 1, ]
col <- ifelse(d$Tratamiento == "Suplemento", "#E3A33B", "#6E9FD8")
op <- par(mfrow = c(1, 2), mar = c(3, 3, 1.2, 0.5), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.8, cex.lab = 0.9)
matplot(rbind(1, 2), rbind(d$PAS_basal, d$PAS_8sem), type = "b", pch = 20, lty = 1,
        col = col, xlim = c(0.8, 2.2), xaxt = "n", las = 1, bty = "l",
        xlab = "", ylab = "PAS (mmHg)")
axis(1, 1:2, c("Basal", "8 semanas"))
legend("bottomleft", c("Placebo", "Suplemento"), col = c("#6E9FD8", "#E3A33B"), lwd = 2,
       bty = "n", cex = 0.7)
dif <- d$PAS_8sem - d$PAS_basal
stripchart(dif ~ d$Tratamiento, vertical = TRUE, method = "jitter", pch = 20,
           col = c("#6E9FD8", "#E3A33B"), las = 1, ylab = "Diferencia (8 sem - basal)")
abline(h = 0, lty = 2)
mtext(sprintf("t pareada: p = %.3f", t.test(d$PAS_8sem, d$PAS_basal, paired = TRUE)$p.value),
      side = 3, line = 0.1, cex = 0.75)
par(op)
