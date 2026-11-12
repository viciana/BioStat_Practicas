# poblacion.omv: PCR (muy asimétrica) en fumadores y no fumadores, con todos los datos (N = 2000):
# t de Student frente a U de Mann-Whitney
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
fp <- function(p) if (p < 0.00001) "< 0.00001" else sprintf("= %.5f", p)   # p sin exceso de decimales
d <- data                                            # datos totales, sin filtro
col <- c("#6E9FD8", "#E3A33B")
op <- par(mfrow = c(1, 2), mar = c(3, 3, 2, 0.5), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.8, cex.lab = 0.9)
hist(d$PCR, breaks = 30, col = "#A8C6EE", border = "grey30", las = 1, main = "",
     xlab = "PCR (mg/L)", ylab = "Frecuencia")
mtext(paste("Shapiro-Wilk: p", fp(shapiro.test(d$PCR)$p.value)), side = 3,
      line = 0.2, cex = 0.7)
boxplot(PCR ~ Fumador, d, col = col, las = 1, xlab = "Fumador", ylab = "PCR (mg/L)",
        outcex = 0.5)
pt <- t.test(PCR ~ Fumador, d, var.equal = TRUE)$p.value   # t de Student, como en jamovi
pw <- wilcox.test(PCR ~ Fumador, d, exact = FALSE)$p.value
mtext(paste0("t: p ", fp(pt), "\nM-W: p ", fp(pw)), side = 3, line = 0.1, cex = 0.65)
par(op)
