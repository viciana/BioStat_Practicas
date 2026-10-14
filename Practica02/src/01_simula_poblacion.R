# ---------------------------------------------------------------------
# 01_simula_poblacion.R
# Simula una POBLACIÓN conocida (N = 2000) de pacientes hipertensos de un
# ensayo clínico (Placebo / Fármaco) y marca dos muestras aleatorias:
#   Muestra_grande (n = 300) y Muestra_peq (n = 30, contenida en la grande)
# La idea (heredada de muestrasB2.omv, curso 2025-26): los alumnos hacen
# inferencia con las muestras (filtros de jamovi) y la comparan con la
# «verdad» de la población, que aquí sí conocemos.
#   datos/poblacion.csv   datos/poblacion.omv
# Ejecutar desde practica02:   Rscript src/01_simula_poblacion.R
# ---------------------------------------------------------------------
library(jmvReadWrite)
set.seed(20261014)
N <- 2000

Sexo      <- rbinom(N, 1, 0.48) + 1                       # 1 Hombre, 2 Mujer
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
Colesterol <- round(rnorm(N, 205 + 6 * (Sexo == 2) + 8 * Fumador, 35))

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

pob <- data.frame(ID = seq_len(N), Sexo, Edad, GrupoSang, Fumador, Ejercicio,
                  Tratamiento, PAS_basal, PAS_8sem, Mejora, Colesterol, PCR,
                  Dolor, EfAdverso, Infarto, Muestra_grande, Muestra_peq)
write.csv(pob, "datos/poblacion.csv", row.names = FALSE)

## Versión jamovi: tipos, etiquetas y descripciones ------------------------
omv <- pob
noSi <- function(x) factor(x, 0:1, c("No", "Sí"))
omv$Sexo        <- factor(omv$Sexo, 1:2, c("Hombre", "Mujer"))
omv$GrupoSang   <- factor(omv$GrupoSang, c("A", "B", "AB", "O"))
omv$Fumador     <- noSi(omv$Fumador)
omv$Ejercicio   <- factor(omv$Ejercicio, 1:3, c("Sedentario", "Moderado", "Intenso"),
                          ordered = TRUE)
omv$Tratamiento <- factor(omv$Tratamiento, 0:1, c("Placebo", "Fármaco"))
omv$Mejora      <- noSi(omv$Mejora)
omv$EfAdverso   <- noSi(omv$EfAdverso)
omv$Infarto     <- noSi(omv$Infarto)
desc <- list(
  ID = "Identificador del paciente",
  Sexo = "Sexo", Edad = "Edad (años)", GrupoSang = "Grupo sanguíneo",
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

## Comprobaciones rápidas (la «verdad» poblacional) -----------------------
cat("Diferencia PAS (basal - 8 sem) por tratamiento:\n")
print(tapply(pob$PAS_basal - pob$PAS_8sem, omv$Tratamiento, mean))
cat("Colesterol por sexo:\n"); print(tapply(pob$Colesterol, omv$Sexo, mean))
cat("Efecto adverso (muestra grande):\n")
print(with(omv[pob$Muestra_grande == 1, ], table(Tratamiento, EfAdverso)))
cat("Infarto x Fumador (población):\n"); print(with(omv, table(Fumador, Infarto)))
