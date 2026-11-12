# poblacion.omv: tabla 2x2 Fumador x Infarto (muestra grande) en 3D.
# Arriba: observadas (O) y esperadas (E) de cada celda, en la diagonal de su cuadrante,
#         unidas por una arista (su pendiente es O - E).
# Abajo: lo que cada celda aporta al chi2, (O - E)^2 / E, como masa (línea y punto).
# Solo R base (persp + trans3d): funciona igual en R y en Rj.
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
if (!exists("estilo")) estilo <- "barras"              # "barras" o "masas" (línea y punto) arriba
d <- data[data$Muestra_grande == 1, ]
tab <- table(d$Fumador, d$Infarto, dnn = c("Fumador", "Infarto"))
ch  <- suppressWarnings(chisq.test(tab, correct = FALSE))
O <- unclass(tab); E <- ch$expected; A <- (O - E)^2 / E
colO <- "steelblue"; colE <- "grey70"; colA <- "firebrick"

## Escena 3D: suelo 2x2, celda (i, j) centrada en (i, j); i = Fumador, j = Infarto.
## Vista desde la esquina (Sí, Sí): las celdas pequeñas delante, la grande (No, No) al fondo.
escena <- function(zmax, zlab, titulo) {
  pm <- persp(c(0.5, 2.5), c(0.5, 2.5), matrix(0, 2, 2), zlim = c(0, zmax),
              theta = 140, phi = 24, r = 4, d = 1.5, expand = 0.8, border = NA,
              col = NA, box = FALSE)
  P <- function(x, y, z) trans3d(x, y, z, pm)
  for (k in pretty(c(0, zmax), 4)) if (k > 0 && k <= zmax) {   # referencias en las paredes del fondo
    lines(P(c(2.5, 0.5, 0.5), c(0.5, 0.5, 2.5), k), col = "grey85")
    text(P(2.5, 0.5, k), labels = k, pos = 2, cex = 0.55, col = "grey40")
  }
  for (q in list(c(2.5, 0.5), c(0.5, 0.5), c(0.5, 2.5)))     # aristas verticales del fondo
    lines(P(c(q[1], q[1]), c(q[2], q[2]), c(0, zmax)), col = "grey60")
  text(P(2.5, 0.5, zmax), labels = zlab, pos = 3, cex = 0.6, col = "grey30")
  for (k in c(0.5, 1.5, 2.5)) {                       # cuadrícula del suelo
    lines(P(c(0.5, 2.5), c(k, k), 0), col = "grey45")
    lines(P(c(k, k), c(0.5, 2.5), 0), col = "grey45")
  }
  text(P(c(1, 2), 2.9, 0), labels = paste("Fumador", rownames(O)), cex = 0.6, adj = c(0, 1))
  text(P(2.9, c(1, 2), 0), labels = paste("Infarto", colnames(O)), cex = 0.6, adj = c(1, 1))
  mtext(titulo, side = 3, line = -0.4, cex = 0.68)
  list(pm = pm, P = P)
}
fondo <- function(pm, i, j) { v <- c(i, j, 0, 1) %*% pm; v[3] / v[4] }   # profundidad
caja <- function(P, x, y, w, h, col) {                # prisma: caras ocultas primero
  x0 <- x - w; x1 <- x + w; y0 <- y - w; y1 <- y + w
  cara <- function(xx, yy, zz, f) polygon(P(xx, yy, zz), col = adjustcolor(col, f),
                                          border = "grey25", lwd = 0.4)
  cara(c(x0, x1, x1, x0), c(y0, y0, y0, y0), c(0, 0, h, h), 0.7)   # atrás
  cara(c(x0, x0, x0, x0), c(y0, y1, y1, y0), c(0, 0, h, h), 0.7)   # atrás
  cara(c(x1, x1, x1, x1), c(y0, y1, y1, y0), c(0, 0, h, h), 0.8)   # delante
  cara(c(x0, x1, x1, x0), c(y1, y1, y1, y1), c(0, 0, h, h), 1)     # delante
  cara(c(x0, x1, x1, x0), c(y0, y0, y1, y1), c(h, h, h, h), 0.45)  # tapa
}
masa <- function(P, x, y, h, col, cex = 1) {
  lines(P(c(x, x), c(y, y), c(0, h)), col = col, lwd = 2.2)
  points(P(x, y, h), pch = 19, col = col, cex = cex)
}

op <- par(mfrow = c(2, 1), mar = c(0, 0, 0.6, 0), xpd = NA)
## Arriba: observadas y esperadas
zmax <- 1.1 * max(O, E)
s <- escena(zmax, "Pacientes", sprintf("O y E:  χ² = %.2f, gl = 1, p %s",
            ch$statistic, ifelse(ch$p.value < 0.001, "< 0.001", sprintf("= %.3f", ch$p.value))))
orden <- expand.grid(i = 1:2, j = 1:2)               # de atrás hacia delante
orden <- orden[order(mapply(function(i, j) fondo(s$pm, i, j), orden$i, orden$j)), ]
for (r in seq_len(nrow(orden))) {
  i <- orden$i[r]; j <- orden$j[r]
  pO <- c(i - 0.2, j + 0.2); pE <- c(i + 0.2, j - 0.2)  # diagonal del cuadrante
  if (estilo == "barras") {
    caja(s$P, pO[1], pO[2], 0.12, O[i, j], colO)
    caja(s$P, pE[1], pE[2], 0.12, E[i, j], colE)
  } else {
    masa(s$P, pO[1], pO[2], O[i, j], colO); masa(s$P, pE[1], pE[2], E[i, j], colE)
  }
  lines(s$P(c(pO[1], pE[1]), c(pO[2], pE[2]), c(O[i, j], E[i, j])), lwd = 1.6, col = "black")
  text(s$P(pO[1], pO[2], O[i, j]), labels = O[i, j], pos = 3, cex = 0.55, col = colO)
  text(s$P(pE[1], pE[2], E[i, j]), labels = sprintf("%.1f", E[i, j]), pos = 2, cex = 0.55, col = "grey35")
}
legend("right", c("Observadas (O)", "Esperadas (E)"), fill = c(colO, colE), bty = "n", cex = 0.6)
## Abajo: aportación de cada celda al chi2
s <- escena(1.15 * max(A), "(O-E)²/E", sprintf("(O - E)²/E de cada celda; suma = χ² = %.2f", ch$statistic))
for (r in seq_len(nrow(orden))) {
  i <- orden$i[r]; j <- orden$j[r]
  masa(s$P, i, j, A[i, j], colA, 1.1)
  text(s$P(i, j, A[i, j]), labels = sprintf("%.2f", A[i, j]), pos = 4, cex = 0.6, col = colA)
}
par(op)
