# ---------------------------------------------------------------------
# 30_resultados.R
# Tablas de SOLUCIONES de las preguntas Q.02-Q.11, calculadas con
# datos/poblacion.omv tal y como las da jamovi (t de Student por defecto,
# Levene centrado en la media, Shapiro-Wilk sobre los residuos, IC de
# la proporción exacto de Clopper-Pearson, OR y RR con IC de Wald).
# Salida: img/res_*.tex (tablas booktabs que se insertan con \input).
# Formato con PUNTO decimal, como lo muestra jamovi en clase. Los valores
# poblacionales y los del ANOVA se citan en el texto de las diapositivas.
# Ejecutar desde Practica02:   Rscript src/30_resultados.R
# ---------------------------------------------------------------------
source("src/estilo_jmv.R")                # tabla_tex(), f1(), f2(), f3()
d <- jmvReadWrite::read_omv("datos/poblacion.omv")
P <- d[d$Muestra_peq == 1, ]; G <- d[d$Muestra_grande == 1, ]
M <- list("Pequeña" = P, "Grande" = G, "Población" = d)    # n = 30, 300 y 2000

fp  <- function(p) ifelse(p < 0.001, "< .001", f3(p))
ic  <- function(a, b) sprintf("%s a %s", f1(a), f1(b))
ic2 <- function(a, b) sprintf("%s a %s", f2(a), f2(b))
levene <- function(y, g) {                   # Levene centrado en la media
  z <- abs(y - ave(y, g)); anova(lm(z ~ g))[["Pr(>F)"]][1] }
sw_res <- function(y, g) shapiro.test(y - ave(y, g))$p.value
mw  <- function(y, g) suppressWarnings(wilcox.test(y ~ g))
chi <- function(t, ...) suppressWarnings(chisq.test(t, ...))

## Q.02 t para una muestra: PAS_basal, H0: mu = 148 --------------------
mu0 <- 148
q02 <- do.call(rbind, lapply(names(M)[1:2], function(m) {
  x <- M[[m]]$PAS_basal; tt <- t.test(x, mu = mu0)
  tu <- t.test(x, mu = mu0, alternative = "greater")
  data.frame(Muestra = m, Media = f1(mean(x)), DT = f1(sd(x)),
             t = f2(tt$statistic), gl = tt$parameter, `p (≠)` = fp(tt$p.value),
             `p (>)` = fp(tu$p.value), Dif = f1(mean(x) - mu0),
             `IC 95 % dif.` = ic(tt$conf.int[1] - mu0, tt$conf.int[2] - mu0),
             `SW p` = fp(shapiro.test(x)$p.value), check.names = FALSE)
}))
# jamovi da la diferencia de medias (x - 148) y SU intervalo, no el de mu
names(q02) <- c("Muestra", "$\\bar{x}$", "$S$", "$t$", "gl", "$p$ ($\\neq$)", "$p$ ($>$)",
                "Dif. ($\\bar{x}-148$)", "IC 95\\,\\% dif.", "Shapiro-Wilk $p$")
tabla_tex(q02, "res_q02_t.tex", "lrrrrrrrcr")

## Q.02 prueba binomial: proporción de mujeres frente a 0,48 -----------
q02b <- do.call(rbind, lapply(names(M), function(m) {
  x <- M[[m]]; k <- sum(x$Sexo == "Mujer"); n <- nrow(x); b <- binom.test(k, n, 0.48)
  data.frame(Muestra = m, Mujeres = k, n = n, Prop = f3(k / n),
             p = if (m == "Población") "---" else fp(b$p.value),
             IC = if (m == "Población") "(parámetro)" else sprintf("%s a %s", f3(b$conf.int[1]), f3(b$conf.int[2])))
}))
names(q02b)[4:6] <- c("Proporción", "$p$ (H$_0$: 0.48)", "IC 95\\,\\% (exacto)")
tabla_tex(q02b, "res_q02_bin.tex", "lrrrrc")

## Tablas 2x2 / NxM -------------------------------------------------------
# Tabla de frecuencias con % por filas, al estilo de jamovi
tabla_pc <- function(t, fichero, fila, col) {
  pc <- 100 * prop.table(t, 1)
  df <- data.frame(rownames(t), check.names = FALSE)
  for (j in colnames(t)) df[[j]] <- sprintf("%d (%s\\,\\%%)", t[, j], f1(pc[, j]))
  df$Total <- rowSums(t)
  names(df)[1] <- sprintf("%s $\\backslash$ %s", fila, col)
  tabla_tex(df, fichero, paste0("l", strrep("r", ncol(df) - 1)))
}
# Pruebas: chi2, Yates, Fisher y frecuencia esperada mínima
pruebas <- function(lst) do.call(rbind, lapply(names(lst), function(m) {
  t <- lst[[m]]; c0 <- chi(t, correct = FALSE)
  data.frame(Muestra = m, `chi2` = f2(c0$statistic), gl = c0$parameter,
             p = fp(c0$p.value),
             Yates = if (all(dim(t) == 2)) fp(chi(t)$p.value) else "---",
             Fisher = fp(fisher.test(t)$p.value),
             Emin = f2(min(c0$expected)),
             E5 = sprintf("%d de %d", sum(c0$expected < 5), length(t)), check.names = FALSE)
}))
cab_pruebas <- c("Muestra", "$\\chi^2$", "gl", "$p$ ($\\chi^2$)", "$p$ (Yates)",
                 "$p$ (Fisher)", "$E$ mínima", "$E<5$")
# Medidas de efecto 2x2 (fila 2 frente a fila 1, columna 2 = suceso)
efecto <- function(t) {
  a <- t[2, 2]; b <- t[2, 1]; c <- t[1, 2]; dd <- t[1, 1]
  p1 <- a / (a + b); p0 <- c / (c + dd)
  rr <- p1 / p0; se_rr <- sqrt(1/a - 1/(a + b) + 1/c - 1/(c + dd))
  or <- a * dd / (b * c); se_or <- sqrt(1/a + 1/b + 1/c + 1/dd)
  data.frame(Medida = c("Diferencia de proporciones", "Riesgo relativo (RR)", "Razón de odds (OR)"),
             Valor = c(f3(p1 - p0), f2(rr), f2(or)),
             IC = c(ic2(p1 - p0 - 1.96 * sqrt(p1*(1-p1)/(a+b) + p0*(1-p0)/(c+dd)),
                        p1 - p0 + 1.96 * sqrt(p1*(1-p1)/(a+b) + p0*(1-p0)/(c+dd))),
                    ic2(rr * exp(-1.96 * se_rr), rr * exp(1.96 * se_rr)),
                    ic2(or * exp(-1.96 * se_or), or * exp(1.96 * se_or))))
}
cab_efecto <- c("Medida", "Valor", "IC 95\\,\\%")

## Q.03 Fumador x Infarto
tf <- lapply(M, function(x) table(Fumador = x$Fumador, Infarto = x$Infarto))
tabla_pc(tf[[2]], "res_q03_tabla.tex", "Fumador", "Infarto")
q03 <- pruebas(tf); names(q03) <- cab_pruebas; tabla_tex(q03, "res_q03_pruebas.tex", "lrrrrrrr")
e03 <- rbind(cbind(Muestra = "Grande", efecto(tf[[2]])), cbind(Muestra = "Población", efecto(tf[[3]])))
names(e03)[-1] <- cab_efecto; tabla_tex(e03, "res_q03_efecto.tex", "llrc")

## Q.04 Tratamiento x EfAdverso
te <- lapply(M, function(x) table(Tratamiento = x$Tratamiento, EfAdverso = x$EfAdverso))
tabla_pc(te[[1]], "res_q04_tabla_peq.tex", "Tratamiento", "EfAdverso")
tabla_pc(te[[2]], "res_q04_tabla_gr.tex", "Tratamiento", "EfAdverso")
q04 <- pruebas(te); names(q04) <- cab_pruebas; tabla_tex(q04, "res_q04_pruebas.tex", "lrrrrrrr")
e04 <- rbind(cbind(Muestra = "Grande", efecto(te[[2]])), cbind(Muestra = "Población", efecto(te[[3]])))
names(e04)[-1] <- cab_efecto; tabla_tex(e04, "res_q04_efecto.tex", "llrc")

## Q.05 Educa x Fumador (3x2) y GrupoSang x Infarto (4x2)
tx <- lapply(M, function(x) table(Educa = x$Educa, Fumador = x$Fumador))
t5 <- tx[[2]]; c5 <- chi(t5); pc <- 100 * prop.table(t5, 1)
q05 <- data.frame(Educa = rownames(t5),
                  No = sprintf("%d (%s\\,\\%%)", t5[, 1], f1(pc[, 1])),
                  Si = sprintf("%d (%s\\,\\%%)", t5[, 2], f1(pc[, 2])),
                  E = f1(c5$expected[, 2]), R = f2(c5$stdres[, 2]),
                  Pob = sprintf("%s\\,\\%%", f1(100 * prop.table(tx[[3]], 1)[, 2])))
names(q05) <- c("Educa", "No fuma", "Fuma", "$E$ (fuma)", "Residuo tipif.", "\\% fuma (pobl.)")
tabla_tex(q05, "res_q05_tabla.tex", "lrrrrr")
q05p <- pruebas(c(tx[1:2], list(`GrupoSang × Infarto (grande)` =
                  table(G$GrupoSang, G$Infarto))))
names(q05p) <- cab_pruebas; q05p[[1]] <- sub("×", "$\\\\times$", q05p[[1]])
tabla_tex(q05p, "res_q05_pruebas.tex", "lrrrrrrr")

## Q.06 McNemar: HTA basal frente a HTA a las 8 semanas (grande) ------------
q06 <- do.call(rbind, lapply(c("Placebo", "Fármaco"), function(g) {
  x <- G[G$Tratamiento == g, ]; t <- table(x$HTA_basal, x$HTA_8sem)
  data.frame(Grupo = g, n = nrow(x),
             Basal = sprintf("%s\\,\\%%", f1(100 * mean(x$HTA_basal == "Sí"))),
             Sem8 = sprintf("%s\\,\\%%", f1(100 * mean(x$HTA_8sem == "Sí"))),
             SiNo = t["Sí", "No"], NoSi = t["No", "Sí"],
             chi = f2(mcnemar.test(t, correct = FALSE)$statistic),
             p = fp(mcnemar.test(t, correct = FALSE)$p.value))
}))
names(q06) <- c("Grupo", "$n$", "HTA basal", "HTA 8 sem", "Sí$\\to$No", "No$\\to$Sí",
                "$\\chi^2$ McNemar", "$p$")
tabla_tex(q06, "res_q06.tex", "lrrrrrrr")

## Dos medias independientes ------------------------------------------------
indep <- function(var, grupo, lst = M[1:2]) do.call(rbind, lapply(names(lst), function(m) {
  x <- lst[[m]]; y <- x[[var]]; g <- droplevels(x[[grupo]]); n <- table(g)
  st <- t.test(y ~ g, var.equal = TRUE); we <- t.test(y ~ g)
  data.frame(Muestra = m, Medias = paste(f1(tapply(y, g, mean)), collapse = " / "),
             Dif = f1(-diff(tapply(y, g, mean))), IC = ic(st$conf.int[1], st$conf.int[2]),
             t = f2(st$statistic), p = fp(st$p.value), Welch = fp(we$p.value),
             Lev = fp(levene(y, g)), SW = fp(sw_res(y, g)))
}))
cab_indep <- function(g1, g2) c("Muestra", sprintf("Medias (%s / %s)", g1, g2),
  "Diferencia", "IC 95\\,\\% dif.", "$t$", "$p$ Student", "$p$ Welch", "Levene $p$", "S-W $p$")
q07 <- indep("PAS_8sem", "Tratamiento"); names(q07) <- cab_indep("Plac.", "Fárm.")
tabla_tex(q07, "res_q07.tex", "lrrcrrrrr")
q08 <- indep("Colesterol", "Sexo"); names(q08) <- cab_indep("M", "H")
tabla_tex(q08, "res_q08.tex", "lrrcrrrrr")

## Q.09 PCR por tabaco y Dolor por tratamiento: t frente a Mann-Whitney ------
q09 <- do.call(rbind, lapply(list(c("PCR", "Fumador"), c("Dolor", "Tratamiento")), function(v)
  do.call(rbind, lapply(names(M)[1:2], function(m) {
    x <- M[[m]]; y <- x[[v[1]]]; g <- x[[v[2]]]; w <- mw(y, g)
    data.frame(Var = sprintf("%s por %s", v[1], v[2]), Muestra = m,
               Medias = paste(f1(tapply(y, g, mean)), collapse = " / "),
               Medianas = paste(f1(tapply(y, g, median)), collapse = " / "),
               p = fp(t.test(y ~ g, var.equal = TRUE)$p.value),
               U = format(unname(w$statistic)), pmw = fp(w$p.value),
               SW = fp(sw_res(y, g)))
  }))))
q09$Var[c(2, 4)] <- ""
names(q09) <- c("Variable", "Muestra", "Medias", "Medianas", "$p$ ($t$)", "$U$", "$p$ (M-W)", "S-W $p$")
tabla_tex(q09, "res_q09.tex", "llrrrrrr")

## Q.10 Pareadas: PAS_basal - PAS_8sem ---------------------------------------
q10 <- do.call(rbind, lapply(names(M)[1:2], function(m)
  do.call(rbind, lapply(c("Todos", "Placebo", "Fármaco"), function(g) {
    x <- M[[m]]; if (g != "Todos") x <- x[x$Tratamiento == g, ]
    dif <- x$PAS_basal - x$PAS_8sem; tt <- t.test(dif)
    wi <- suppressWarnings(wilcox.test(x$PAS_basal, x$PAS_8sem, paired = TRUE))
    data.frame(Muestra = m, Grupo = g, n = nrow(x), Dif = f1(mean(dif)),
               IC = ic(tt$conf.int[1], tt$conf.int[2]), t = f2(tt$statistic),
               p = fp(tt$p.value), pw = fp(wi$p.value),
               pind = fp(t.test(x$PAS_basal, x$PAS_8sem, var.equal = TRUE)$p.value))
  }))))
q10$Muestra[duplicated(q10$Muestra)] <- ""
names(q10) <- c("Muestra", "Grupo", "$n$", "Bajada media", "IC 95\\,\\%", "$t$",
                "$p$ ($t$ pareada)", "$p$ (Wilcoxon)", "$p$ (\\textcolor{red}{indep.})")
tabla_tex(q10, "res_q10.tex", "llrrcrrrr")

## Más de dos grupos: PAS basal por nivel educativo (muestra grande) ---------
anv <- data.frame(Educa = levels(G$Educa), n = as.vector(table(G$Educa)),
                  Media = f1(tapply(G$PAS_basal, G$Educa, mean)),
                  DT = f1(tapply(G$PAS_basal, G$Educa, sd)))
names(anv)[4] <- "DT"
tabla_tex(anv, "res_anova.tex", "lrrr")

cat("Tablas de resultados escritas en img/res_*.tex\n")
