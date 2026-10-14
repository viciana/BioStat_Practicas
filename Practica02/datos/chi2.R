# poblacion.omv: tabla 2x2 Fumador x Infarto (muestra grande), observadas vs esperadas
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
d <- data[data$Muestra_grande == 1, ]
tab <- table(d$Fumador, d$Infarto, dnn = c("Fumador", "Infarto"))
ch <- suppressWarnings(chisq.test(tab, correct = FALSE))
op <- par(mar = c(3, 3, 1.2, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
m <- rbind(Observadas = as.vector(tab), Esperadas = as.vector(ch$expected))
nom <- paste0("Fum.", rep(rownames(tab), 2), "\nInf.", rep(colnames(tab), each = 2))
b <- barplot(m, beside = TRUE, names.arg = nom, las = 1, col = c("steelblue", "grey80"),
             ylim = c(0, max(m) * 1.15), cex.names = 0.7, ylab = "Pacientes")
text(b, m, round(m, 1), pos = 3, cex = 0.6)
legend("topright", rownames(m), fill = c("steelblue", "grey80"), bty = "n", cex = 0.75)
mtext(sprintf("Chi2 = %.2f  gl = %d  p %s", ch$statistic, ch$parameter,
              ifelse(ch$p.value < 0.001, "< 0.001", sprintf("= %.3f", ch$p.value))),
      side = 3, line = 0.1, cex = 0.8)
par(op)
