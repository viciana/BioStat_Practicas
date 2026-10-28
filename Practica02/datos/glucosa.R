# Simulación: glucosa basal (mg/dL) en 1000 individuos SANOS y 1000 ENFERMOS
# (diabéticos). Prueba diagnóstica con umbral 120 mg/dL vista como contraste:
#   H0: «el individuo está SANO»
#   Test positivo (glucosa > umbral) = rechazar H0
#   Falso positivo (FP) = rechazar H0 siendo cierta  -> error tipo I  (alfa)
#   Falso negativo (FN) = no rechazar H0 siendo falsa -> error tipo II (beta)
# Prueba a cambiar 'umbral' o la media de los enfermos (175: bien separados)
# y mira cómo cambian alfa y beta.
# No necesita datos: funciona igual en R y en Rj (JAMOVI).
set.seed(5)
umbral  <- 120
sano    <- c(media = 90,  de = 15)
enfermo <- c(media = 140, de = 20)
col_s <- "#6E9FD8"; col_e <- "#E3A33B"                  # sanos / enfermos
op <- par(mar = c(3, 0.6, 1.6, 0.6), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.75, cex.lab = 0.85)
s <- rnorm(1000, sano["media"], sano["de"])
e <- rnorm(1000, enfermo["media"], enfermo["de"])
br <- seq(0, 300, by = 5)
hs <- hist(s, br, plot = FALSE); he <- hist(e, br, plot = FALSE)
plot(NA, xlim = c(40, 210), ylim = c(0, 0.042), yaxt = "n", bty = "n",
     xlab = "Glucosa basal (mg/dL)", ylab = "")
rect(br[-length(br)], 0, br[-1], hs$density, col = adjustcolor(col_s, 0.35), border = NA)
rect(br[-length(br)], 0, br[-1], he$density, col = adjustcolor(col_e, 0.35), border = NA)
x <- seq(40, 240, length = 400)
# colas teóricas: FP (sanos por encima del umbral), FN (enfermos por debajo)
u <- x[x >= umbral]; polygon(c(umbral, u, max(u)), c(0, dnorm(u, sano[1], sano[2]), 0),
                             col = adjustcolor("firebrick", 0.7), border = NA)
u <- x[x <= umbral]; polygon(c(min(u), u, umbral), c(0, dnorm(u, enfermo[1], enfermo[2]), 0),
                             col = adjustcolor("darkgreen", 0.7), border = NA)
lines(x, dnorm(x, sano[1], sano[2]), col = col_s, lwd = 2)
lines(x, dnorm(x, enfermo[1], enfermo[2]), col = col_e, lwd = 2)
abline(v = umbral, lty = 2)
FP <- sum(s > umbral); FN <- sum(e < umbral)
VN <- 1000 - FP;       VP <- 1000 - FN
text(sano[1] - 21, 0.030, "SANO", col = col_s, cex = 0.8, font = 2)
text(sano[1] - 21, 0.027, expression(H[0] ~ "cierta"), col = col_s, cex = 0.65)
text(enfermo[1] + 36, 0.024, "ENFERMO", col = col_e, cex = 0.8, font = 2)
text(enfermo[1] + 36, 0.021, expression(H[0] ~ "falsa"), col = col_e, cex = 0.65)
text(umbral - 4, 0.035, sprintf("umbral %d", umbral), cex = 0.6, srt = 90)
mtext("Test negativo", side = 3, line = -0.4, at = umbral - 22, cex = 0.6)
mtext("Test positivo", side = 3, line = -0.4, at = umbral + 22, cex = 0.6)
arrows(128, 0.0225, 123.5, 0.0025, length = 0.05, col = "firebrick")
text(133, 0.0245, expression(alpha ~ "(FP)"), col = "firebrick", cex = 0.75, font = 2)
arrows(105, 0.0125, 113, 0.0040, length = 0.05, col = "darkgreen")
text(102, 0.0145, expression(beta ~ "(FN)"), col = "darkgreen", cex = 0.75, font = 2)
legend("topright", inset = c(0, 0.10), bty = "n", cex = 0.55, text.col =
         c("firebrick", "darkgreen", "black", "black"),
       legend = c(sprintf("FP = %d  (tipo I, alfa = %.1f %%)", FP, FP / 10),
                  sprintf("FN = %d  (tipo II, beta = %.1f %%)", FN, FN / 10),
                  sprintf("Especificidad = %.1f %%", VN / 10),
                  sprintf("Sensibilidad = %.1f %%", VP / 10)))
par(op)
