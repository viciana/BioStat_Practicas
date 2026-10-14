# Simulación: glucosa basal (mg/dL) en 1000 no diabéticos y 1000 diabéticos.
# Prueba diagnóstica con umbral 120 mg/dL vista como contraste de hipótesis:
#   H0: «el paciente NO es diabético»
#   Falso positivo (FP) = rechazar H0 siendo cierta  -> error tipo I  (alfa)
#   Falso negativo (FN) = no rechazar H0 siendo falsa -> error tipo II (beta)
# Dos escenarios: diabéticos bien separados (media 175) y cercanos (media 140)
# No necesita datos: funciona igual en R y en Rj (JAMOVI).
set.seed(5)
umbral <- 120
sanos  <- c(media = 90, de = 15)
escena <- list(c(media = 175, de = 20), c(media = 140, de = 20))
col_s <- "#6E9FD8"; col_d <- "#E3A33B"                  # sanos / diabéticos
op <- par(mfrow = c(1, 2), mar = c(3, 0.6, 1.6, 0.6), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.75, cex.lab = 0.85)
for (dia in escena) {
  s <- rnorm(1000, sanos["media"], sanos["de"])
  d <- rnorm(1000, dia["media"], dia["de"])
  br <- seq(0, 300, by = 5)
  hs <- hist(s, br, plot = FALSE); hd <- hist(d, br, plot = FALSE)
  plot(NA, xlim = c(40, 240), ylim = c(0, 0.042), yaxt = "n", bty = "n",
       xlab = "Glucosa basal (mg/dL)", ylab = "")
  rect(br[-length(br)], 0, br[-1], hs$density, col = adjustcolor(col_s, 0.35), border = NA)
  rect(br[-length(br)], 0, br[-1], hd$density, col = adjustcolor(col_d, 0.35), border = NA)
  x <- seq(40, 240, length = 400)
  # colas teóricas: FP (sanos por encima del umbral), FN (diabéticos por debajo)
  u <- x[x >= umbral]; polygon(c(umbral, u, max(u)), c(0, dnorm(u, sanos[1], sanos[2]), 0),
                               col = adjustcolor("firebrick", 0.7), border = NA)
  u <- x[x <= umbral]; polygon(c(min(u), u, umbral), c(0, dnorm(u, dia[1], dia[2]), 0),
                               col = adjustcolor("darkgreen", 0.7), border = NA)
  lines(x, dnorm(x, sanos[1], sanos[2]), col = col_s, lwd = 2)
  lines(x, dnorm(x, dia[1], dia[2]), col = col_d, lwd = 2)
  abline(v = umbral, lty = 2)
  FP <- sum(s > umbral); FN <- sum(d < umbral)
  VN <- 1000 - FP;       VP <- 1000 - FN
  text(sanos[1] - 12, 0.0290, "No diabéticos", col = col_s, cex = 0.7, font = 2)
  text(dia[1] + 38, dnorm(dia[1], dia[1], dia[2]), "Diabéticos", col = col_d,
       cex = 0.7, font = 2)
  text(umbral - 4, 0.018, sprintf("umbral %d", umbral), cex = 0.6, srt = 90)
  legend("topright", inset = c(0, 0.02), bty = "n", cex = 0.6, text.col =
           c("firebrick", "darkgreen", "black", "black"),
         legend = c(sprintf("FP = %d  (tipo I, alfa = %.1f %%)", FP, FP / 10),
                    sprintf("FN = %d  (tipo II, beta = %.1f %%)", FN, FN / 10),
                    sprintf("Especificidad = %.1f %%", VN / 10),
                    sprintf("Sensibilidad = %.1f %%", VP / 10)))
  mtext(sprintf("Diabéticos: media %d mg/dL", dia[1]), side = 3, line = 0.3,
        cex = 0.75, font = 2)
}
par(op)
