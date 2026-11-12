# poblacion.omv: teorema central del límite.
# En cada panel: histograma de la variable en la población (N = 2000), con encima la
# distribución de las medias de 100 muestras de tamaño n = 5, 15 y 50 (curvas de densidad).
# Tres variables: casi normal (Colesterol), discreta (Dolor) y muy asimétrica (PCR).
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
rangos <- list(Colesterol = NULL, Dolor = NULL, PCR = c(0, 25))   # eje X común (PCR recortada)
vars <- c("Colesterol", "Dolor", "PCR"); ns <- c(5, 15, 50)
col <- c("#A8A8A8", "#E3A33B", "#1F4E9A")
set.seed(11)
op <- par(mfrow = c(1, 3), mar = c(3, 3.4, 1.6, 0.4), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.85, cex.lab = 0.9, cex.main = 1)
for (v in vars) {
  x <- data[[v]]; mu <- mean(x)
  rango <- if (is.null(rangos[[v]])) range(x) else rangos[[v]]
  medias <- lapply(ns, function(n) replicate(100, mean(sample(x, n, replace = TRUE))))
  dens <- lapply(medias, density)
  h <- hist(x, breaks = 30, plot = FALSE)             # histograma de la población (al fondo)
  plot(h, freq = FALSE, col = "#A8C6EE", border = "grey40", las = 1, main = v, xlim = rango,
       ylim = c(0, max(h$density, sapply(dens, function(d) max(d$y)))),
       xlab = "Población y medias muestrales", ylab = "Densidad")
  abline(v = sapply(medias, mean), col = col, lwd = c(6, 3.5, 1.5))
  for (i in seq_along(ns)) lines(dens[[i]], lwd = 2, col = col[i])
  abline(v = mu, lty = 3, lwd = 2)                    # mu (puntos)
  if (v == "Colesterol")
    legend("topleft", c(paste("n =", ns), "media de la población"), lwd = c(2, 2, 2, 2),
           lty = c(1, 1, 1, 3), col = c(col, "black"), bty = "n", cex = 0.8)
}
par(op)
