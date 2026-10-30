# poblacion.omv: IC 95 % y estadístico t, paso a paso, para dos de las 100
# muestras de ic.R (n = 30, colesterol), que llamamos A (la 23: su IC contiene
# a mu) y B (la 77: no lo contiene). Abajo, su t sobre la distribución t (n - 1 gl) bajo
# H0: mu = media poblacional; cada media muestral «cae» en su t.
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!exists("data") || !is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/poblacion.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
mu <- mean(data$Colesterol)                         # media poblacional (conocida)
set.seed(7); n <- 30                                # las mismas 100 muestras que ic.R
muestras <- replicate(100, sample(data$Colesterol, n))
k   <- c(23, 77)                                    # las dos muestras del ejemplo
nom <- c("A", "B")
tc  <- qt(0.975, n - 1)                             # valor crítico (2.045)
m   <- colMeans(muestras[, k]); s <- apply(muestras[, k], 2, sd)
ee  <- s / sqrt(n)                                  # error estándar
li  <- m - tc * ee; ls <- m + tc * ee               # IC 95 %
tt  <- (m - mu) / ee                                # t bajo H0
p   <- 2 * pt(-abs(tt), n - 1)
col <- ifelse(abs(tt) > tc, "firebrick", "steelblue")
tabla <- data.frame(Muestra = nom, Media = m, S = s, EE = ee, IC_inf = li, IC_sup = ls,
                    t = tt, p = p, Rechazo_H0 = abs(tt) > tc)
print(tabla, digits = 4)
for (i in 1:2) cat("Muestra", nom[i], ":", muestras[, k[i]], "\n")

## Un solo sistema de coordenadas: arriba la recta del colesterol (mg/dL) con los
## IC de A y B encima; abajo la densidad t bajo H0, alineada con el
## colesterol: x = mu + t * sigma / sqrt(n)
x_t <- function(t) mu + t * sd(data$Colesterol) / sqrt(n)
tg  <- seq(-4.5, 4.5, length = 600)
y_ax <- 0.70                                       # recta del colesterol
y   <- c(0.905, 0.74)                               # IC de A y de B, sobre la recta
op <- par(mar = c(3, 0.5, 0.3, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.75)
plot(NA, xlim = x_t(c(-4.3, 4.3)), ylim = c(0, 1.03), bty = "n", xaxt = "n", yaxt = "n",
     xlab = bquote("Estadístico" ~ t ~ "bajo" ~ H[0] * ":" ~ mu == .(f <- sprintf("%.1f", mu)) ~
                   "(" * .(n - 1) ~ "gl)"), ylab = "")
axis(1, at = seq(190, 240, 10), pos = y_ax, tcl = -0.2, mgp = c(0, 0.1, 0), cex.axis = 0.6)
text(par("usr")[2], y_ax - 0.145, "Colesterol (mg/dL)", cex = 0.55, adj = 1)
axis(1, at = x_t(-4:4), labels = -4:4)
## 1) Al fondo: el cálculo de t, sobre el punto medio de cada flecha
y0 <- y - 0.02                                      # salida de las flechas (bajo cada IC)
ym <- c(0.5, 0.3)                                   # altura del cálculo de t
xm <- m + (x_t(tt) - m) * (y0 - ym) / (y0 - 0.035)
for (i in 1:2)
  text(xm[i], ym[i], cex = 0.5, col = adjustcolor(col[i], 0.85),
       bquote(t == frac(.(sprintf("%.1f", m[i])) - .(f), .(sprintf("%.2f", ee[i]))) *
              " = " * .(sprintf("%.2f", tt[i]))))

## 2) Encima: regiones, curva t, mu y valores críticos
for (sg in c(-1, 1)) {                              # región de rechazo (rojo)
  u <- tg[sg * tg >= tc]
  polygon(x_t(c(sg * tc, u, sg * tc)), c(0, dt(u, n - 1), 0),
          col = adjustcolor("firebrick", 0.35), border = NA)
}
u <- tg[abs(tg) <= tc]                              # región de aceptación (azul)
polygon(x_t(c(-tc, u, tc)), c(0, dt(u, n - 1), 0),
        col = adjustcolor("steelblue", 0.12), border = NA)
lines(x_t(tg), dt(tg, n - 1), lwd = 1.5)
segments(mu, 0, mu, 0.97, lty = 2)
text(mu, 0.555, bquote(mu == .(f)), cex = 0.6, pos = 4, offset = 0.15)
text(mu, c(0.2, 0.15), c("región de aceptación", expression("de" ~ H[0])), cex = 0.55,
     col = "steelblue4")
for (sg in c(-1, 1))                                # dos líneas en cada cola
  text(x_t(sg * 3.55), c(0.15, 0.1), c("región de rechazo", expression("de" ~ H[0])),
       cex = 0.5, col = "firebrick")
segments(x_t(c(-1, 1) * tc), 0, x_t(c(-1, 1) * tc), 0.42, col = "firebrick", lwd = 1.2)
text(x_t(c(-1, 1) * tc), 0.075, sprintf("%+.3f", c(-1, 1) * tc), cex = 0.5, col = "firebrick",
     pos = c(2, 4), offset = 0.15)
text(x_t(tc), 0.43, expression("valor crítico (" * alpha == 0.05 * ")"), cex = 0.5,
     col = "firebrick", pos = 4, offset = 0.1)

## 3) Los IC con sus estadísticos (letra pequeña, fondo blanco) y las flechas
rotulo <- function(x, y, e, cex, ...) {             # texto con fondo blanco
  w <- strwidth(e, cex = cex) / 2 + 0.6; h <- strheight(e, cex = cex) / 2 + 0.008
  x <- min(max(x, par("usr")[1] + w), par("usr")[2] - w)     # sin salirse del gráfico
  rect(x - w, y - h, x + w, y + h, col = "white", border = NA)
  text(x, y, e, cex = cex, ...)
}
for (i in 1:2) {
  segments(li[i], y[i], ls[i], y[i], lwd = 3, col = col[i])
  points(m[i], y[i], pch = 19, cex = 0.8)
  yt <- y[i] + c(0.097, 0.042)                     # texto encima de cada IC
  rotulo(m[i], yt[1], cex = 0.48, bquote("Muestra" ~ .(nom[i]) * ":" ~ bar(x) == .(sprintf("%.1f", m[i])) *
         "," ~ s == .(sprintf("%.1f", s[i])) * "," ~ EE == s / sqrt(.(n)) * " = " * .(sprintf("%.2f", ee[i]))))
  rotulo(m[i], yt[2], cex = 0.48, bquote("IC 95%:" ~ .(sprintf("%.1f", m[i])) %+-%
         .(sprintf("%.3f", tc)) %.% .(sprintf("%.2f", ee[i])) == "[" * .(sprintf("%.1f", li[i])) *
         "," ~ .(sprintf("%.1f", ls[i])) * "]"))
  arrows(m[i], y0[i], x_t(tt[i]), 0.035, length = 0.06, col = col[i], lwd = 1.2)
  points(x_t(tt[i]), 0.02, pch = 19, cex = 1.2, col = col[i])
}
par(op)
