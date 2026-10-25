# ---------------------------------------------------------------------
# 01_simula_poblacion.R
# Simula una POBLACIÓN conocida (N = 2000) de pacientes hipertensos de un
# ensayo clínico (Placebo / Fármaco) y marca dos muestras aleatorias:
#   Muestra_grande (n = 300) y Muestra_peq (n = 30, contenida en la grande)
# La idea (heredada de muestrasB2.omv, curso 2025-26): los alumnos hacen
# inferencia con las muestras (filtros de jamovi) y la comparan con la
# «verdad» de la población, que aquí sí conocemos.
#   datos/poblacion.csv   datos/poblacion.omv
# Las categóricas se guardan como ENTEROS con etiquetas (como al importar
# un CSV en jamovi): en las dicotómicas 0 es la categoría de referencia
# («No», Mujer, Placebo), así su media en jamovi es la proporción de 1.
# Ejecutar desde practica02:   Rscript src/01_simula_poblacion.R
# ---------------------------------------------------------------------
library(jmvReadWrite)
source("src/omv_enteros.R")
set.seed(20261014)
N <- 2000

Mujer     <- rbinom(N, 1, 0.48)
Sexo      <- 1L - Mujer                                   # 0 Mujer, 1 Hombre
Edad      <- round(pmin(pmax(rnorm(N, 58, 12), 25), 90))
GrupoSang <- sample(c("O", "A", "B", "AB"), N, TRUE, c(.43, .42, .11, .04))
Fumador   <- rbinom(N, 1, 0.25)                           # 0 No, 1 Sí
Ejercicio <- sample(1:3, N, TRUE, c(.45, .40, .15))       # ordinal
Tratamiento <- rbinom(N, 1, 0.5)                          # 0 Placebo, 1 Fármaco

## Presión arterial sistólica: basal y a las 8 semanas (medidas pareadas)
PAS_basal <- round(150 + 0.25 * (Edad - 58) + 4 * Fumador + rnorm(N, 0, 12))
PAS_8sem  <- round(PAS_basal - 4 - 8 * Tratamiento +
                   rnorm(N, 0, 9))
Mejora    <- as.integer(PAS_basal - PAS_8sem >= 10)        # respuesta clínica

## Colesterol: diferencia pequeña por sexo (difícil de detectar con n = 30)
Colesterol <- round(rnorm(N, 205 + 6 * (Sexo == 0) + 8 * Fumador, 35))

## Proteína C reactiva (mg/L): muy asimétrica -> pruebas no paramétricas
PCR <- round(exp(rnorm(N, log(2.2) + 0.45 * Fumador + 0.15 * (Ejercicio == 1), 0.9)), 1)

## Dolor de cabeza (escala 0-10, ordinal) al final del ensayo
Dolor <- pmin(pmax(round(rnorm(N, 4.2 - 1.2 * Tratamiento, 2.2)), 0), 10)

## Efecto adverso: raro -> tablas con frecuencias esperadas < 5 (Fisher)
EfAdverso <- rbinom(N, 1, ifelse(Tratamiento == 1, 0.09, 0.03))

## Infarto previo: asociado al tabaco y a la edad (tabla 2x2 «clásica»)
Infarto <- rbinom(N, 1, plogis(-3.3 + 1.7 * Fumador + 0.04 * (Edad - 58)))

## Muestras (filtros) ----------------------------------------------------
idx_g <- sample(N, 300); idx_p <- sample(idx_g, 30)
Muestra_grande <- as.integer(seq_len(N) %in% idx_g)
Muestra_peq    <- as.integer(seq_len(N) %in% idx_p)

## Nivel educativo (ordinal: 1 Básicos, 2 Medios, 3 Superiores) -----------
## Se simula al final, a partir de Edad, Fumador y Ejercicio, para no
## alterar el resto de variables (ni los resultados ya comprobados).
## Variable latente logística cortada en terciles: ~1/3 en cada nivel;
## menor nivel a más edad, en fumadores y en sedentarios.
L_educa <- -1.1 * (Edad - 58) / 12 - 1.0 * Fumador + 0.7 * (Ejercicio - 2) +
           rlogis(N)
Educa   <- cut(L_educa, quantile(L_educa, 0:3 / 3), include.lowest = TRUE,
               labels = FALSE)

pob <- data.frame(ID = seq_len(N), Sexo, Edad, Educa, GrupoSang, Fumador, Ejercicio,
                  Tratamiento, PAS_basal, PAS_8sem, Mejora, Colesterol, PCR,
                  Dolor, EfAdverso, Infarto, Muestra_grande, Muestra_peq)
write.csv(pob, "datos/poblacion.csv", row.names = FALSE)

## Versión jamovi: tipos, etiquetas y descripciones ------------------------
omv <- pob
omv$GrupoSang <- factor(omv$GrupoSang, c("A", "B", "AB", "O"))
noSi <- c("0" = "No", "1" = "Sí")
etiquetas <- list(
  Sexo        = c("0" = "Mujer", "1" = "Hombre"),
  Educa       = c("1" = "Básicos", "2" = "Medios", "3" = "Superiores"),
  Fumador     = noSi,
  Ejercicio   = c("1" = "Sedentario", "2" = "Moderado", "3" = "Intenso"),
  Tratamiento = c("0" = "Placebo", "1" = "Fármaco"),
  Mejora      = noSi,
  EfAdverso   = noSi,
  Infarto     = noSi)
desc <- list(
  ID = "Identificador del paciente",
  Sexo = "Sexo", Edad = "Edad (años)",
  Educa = "Nivel educativo", GrupoSang = "Grupo sanguíneo",
  Fumador = "Fumador actual", Ejercicio = "Actividad física habitual",
  Tratamiento = "Grupo del ensayo (asignación aleatoria)",
  PAS_basal = "Presión arterial sistólica al inicio (mmHg)",
  PAS_8sem = "Presión arterial sistólica a las 8 semanas (mmHg)",
  Mejora = "Bajada de la PAS de 10 mmHg o más",
  Colesterol = "Colesterol total (mg/dL)",
  PCR = "Proteína C reactiva (mg/L)",
  Dolor = "Cefalea al final del ensayo (escala 0-10)",
  EfAdverso = "Efecto adverso durante el ensayo",
  Infarto = "Antecedente de infarto",
  Muestra_grande = "1 = pertenece a la muestra grande (n = 300)",
  Muestra_peq = "1 = pertenece a la muestra pequeña (n = 30)")
for (v in names(desc)) attr(omv[[v]], "jmv-desc") <- desc[[v]]
attr(omv$ID, "jmv-id") <- TRUE
write_omv(omv, "datos/poblacion.omv", frcWrt = TRUE)
etiqueta_enteros("datos/poblacion.omv", etiquetas,
                 ordinales = c("Educa", "Ejercicio"))

## Comprobaciones rápidas (la «verdad» poblacional) -----------------------
for (v in names(etiquetas))                        # factores para las tablas
  omv[[v]] <- factor(pob[[v]], names(etiquetas[[v]]), etiquetas[[v]])
cat("Diferencia PAS (basal - 8 sem) por tratamiento:\n")
print(tapply(pob$PAS_basal - pob$PAS_8sem, omv$Tratamiento, mean))
cat("Colesterol por sexo:\n"); print(tapply(pob$Colesterol, omv$Sexo, mean))
cat("Efecto adverso (muestra grande):\n")
print(with(omv[pob$Muestra_grande == 1, ], table(Tratamiento, EfAdverso)))
cat("Infarto x Fumador (población):\n"); print(with(omv, table(Fumador, Infarto)))
cat("Nivel educativo (población): reparto, edad media, % fumadores y sedentarios:\n")
print(table(omv$Educa))
print(round(rbind(Edad = tapply(pob$Edad, omv$Educa, mean),
                  `% Fumador` = 100 * tapply(pob$Fumador, omv$Educa, mean),
                  `% Sedentario` = 100 * tapply(pob$Ejercicio == 1, omv$Educa, mean)), 1))
