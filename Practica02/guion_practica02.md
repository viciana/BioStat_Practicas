# Guion propuesto — 2ª Práctica de Bioestadística: Inferencia estadística con JAMOVI

*Borrador v0 · 14-10-2026 · 2º Medicina, Grupo B · 4 horas*

Temas del coordinador: **(4)** contraste de hipótesis y tipos de pruebas;
**(5)** comparación de proporciones: χ², Fisher, Yates, tablas de
contingencia; **(6)** comparación de dos medias independientes y
dependientes: pruebas paramétricas y no paramétricas.

Material de partida: `../../S2/ppt02.org` (curso 2025-26). Formato y
herramientas: los de `../Practica01` (org → beamer, datos `.omv`
simulados en R, gráficos R con su script enlazado en el PDF).

## Decisiones de diseño (propuestas)

- **Una población conocida + dos muestras** (idea de `muestrasB2.omv`,
  que funcionó): `poblacion.omv` (N = 2000) con los filtros
  `Muestra_grande` (n = 300) y `Muestra_peq` (n = 30, dentro de la grande).
  El alumno hace inferencia con la muestra y **contrasta con la verdad**
  poblacional. Hilo conductor: un **ensayo clínico de un antihipertensivo**
  (Placebo / Fármaco), que da de forma natural medias independientes,
  pareadas (PAS basal / 8 semanas), proporciones y tablas 2×2.
- **Se recorta** respecto al curso pasado: distribuciones Bernoulli/binomial
  (quedan como 1 diapositiva de repaso), ANOVA/K-W (fuera de temario,
  1 diapositiva «para saber más»), regresión lineal/logística (ya vista en
  la práctica 1).
- **Se amplía**: lógica del p-valor, errores α/β y potencia, elección de la
  prueba (árbol de decisión), Yates y Fisher, no paramétricas.
- **Elementos dinámicos nuevos**: simulación de 100 IC, «la sala vota»
  (predecir antes de calcular), árbol de decisión de pruebas, gráfico
  observado vs esperado en χ², gráfico de pendientes antes/después.

## Estructura jerárquica (sección › diapositiva › contenido)

### 0. Presentación (≈ 10 min)
- **Datos de la práctica**
  - Abrir `poblacion.omv`; diccionario de variables
  - Cómo activar los filtros `Muestra_grande` / `Muestra_peq` en jamovi
- **De la descripción a la inferencia** (de S2)
  - Muestra ↔ población; estadístico ↔ estimador ↔ parámetro (tabla)

### 1. Bases: error estándar e intervalos de confianza (≈ 35 min)
- **Repaso: Normal, Z y t de Student** (1 diapositiva, de S2)
- **Teorema central del límite** (de S2 + simulación jamovi)
  - Error estándar $\sigma/\sqrt{n}$
- **100 intervalos de confianza** *(nuevo gráfico R: `rj_ic.pdf`)*
  - ¿Cuántos IC no atrapan μ? → interpretación correcta del 95 %
- **IC de una media y de una proporción en jamovi** (capturas S2)
- **Q.01** IC del colesterol y de la % de fumadores: muestra grande vs pequeña vs población

### 2. Contraste de hipótesis (tema 4) (≈ 50 min)
- **Lógica del contraste**
  - H₀ / H₁, estadístico de contraste, regla de decisión
  - Analogía del juicio: «inocente hasta que se demuestre lo contrario»
- **El p-valor visto en la distribución t** *(nuevo: `rj_pvalor.pdf`)*
  - Bilateral vs unilateral; α = 0,05
  - Lo que el p-valor **no** es (recuadro naranja)
- **Errores tipo I y II, potencia** (matriz de S2 + ejemplo glucosa/diabetes simulado en R, 5 → 1 diapositiva)
- **Significación estadística vs relevancia clínica**
  - IC de la diferencia como mejor resumen
- **Tipos de pruebas: árbol de decisión** *(nuevo diagrama TikZ)*
  - Tipo de variable respuesta × nº de grupos × independientes/pareadas × normalidad
  - Paramétricas vs no paramétricas; una cola vs dos colas
- **Comparar con un valor de referencia**: t para una muestra y prueba binomial
- **Q.02** ¿La PAS basal media es 150 mmHg? ¿El 48 % son mujeres? (muestra pequeña / grande / población)

### 3. Comparación de proporciones (tema 5) (≈ 50 min)
- **Tablas de contingencia 2×2**: frecuencias observadas y esperadas
  - Gráfico observado vs esperado *(nuevo: `rj_chi2.pdf`)*
- **Prueba χ² de Pearson**: estadístico, gl, condiciones (esperadas ≥ 5)
- **Corrección de Yates**: cuándo y por qué (2×2, n moderado)
- **Test exacto de Fisher**: frecuencias esperadas pequeñas
- **Medidas de efecto**: diferencia de proporciones, RR, OR con IC
- **Jamovi: Frecuencias › Muestras independientes** (captura S2 actualizada)
- **Q.03** Fumador × Infarto (muestra grande): χ², RR, OR
- **Q.04** Tratamiento × Efecto adverso en la muestra pequeña: ¿χ² o Fisher? Comparar χ², Yates y Fisher
- **Tablas N×M** (Educa × Fumador, GrupoSang × Infarto) y residuos
- **Q.05** Educa × Fumador (3×2, gl = 2): muestra grande p = 0,001; pequeña p = 0,88 con esperadas < 5
- **(Opcional) Datos pareados: McNemar** (para saber más)

### 4. Comparación de dos medias (tema 6) (≈ 60 min)
- **Condiciones de aplicación de la t**: normalidad (Shapiro-Wilk, Q-Q), homogeneidad de varianzas (Levene) → Welch
- **Dos medias independientes: t de Student / Welch**
  - Gráfico de medias con IC por grupo *(R)*
- **Q.06** PAS a las 8 semanas: Placebo vs Fármaco (muestra pequeña, grande, población)
- **Q.07** Colesterol por sexo: diferencia real pequeña → error tipo II con n = 30
- **Alternativa no paramétrica: U de Mann-Whitney**
  - Cuando la variable es muy asimétrica (PCR) u ordinal (Dolor 0-10)
- **Q.08** PCR en fumadores vs no fumadores: t vs Mann-Whitney
- **Dos medias dependientes (pareadas)**: diferencias intra-individuo
  - Gráfico de pendientes antes/después *(nuevo: `rj_pareadas.pdf`)*
  - Error típico: analizar pareados como independientes
- **Alternativa no paramétrica: Wilcoxon de rangos con signo**
- **Q.09** ¿Baja la PAS de basal a 8 semanas? En cada grupo de tratamiento; t pareada vs Wilcoxon
- **(Para saber más)** Más de dos grupos: ANOVA y Kruskal-Wallis (1 diapositiva, de S2)

### 5. Cierre (≈ 15 min)
- **Tabla resumen: qué prueba usar** (tabla en una diapositiva)
- **Q.10 integradora**: informe tipo «resultados de un artículo» del ensayo
- **Enlaces**: datos y scripts R en `epidemos.es/bs2026/`

## Ficheros de datos y gráficos previstos

| Fichero | Script | Estado |
|---|---|---|
| `datos/poblacion.{csv,omv}` | `src/01_simula_poblacion.R` | **Hecho** |
| `img/rj_ic.pdf` (100 IC) | `src/10_rj_ic.R` + `datos/ic.R` | **Hecho** |
| `img/rj_pvalor.pdf` | `src/11_rj_pvalor.R` + `datos/pvalor.R` | **Hecho** |
| `img/rj_chi2.pdf` (obs. vs esperadas) | `src/12_rj_chi2.R` + `datos/chi2.R` | **Hecho** |
| `img/rj_pareadas.pdf` | `src/13_rj_pareadas.R` + `datos/pareadas.R` | **Hecho** |
| Árbol de decisión de pruebas (TikZ) | `src/20_arbol_pruebas.tex` | **Hecho** |
| `img/rj_forest.pdf` (diferencia con IC, 3 tamaños) | `src/14_rj_forest.R` + `datos/forest.R` | **Hecho** |
| `img/rj_pcr.pdf` (t vs Mann-Whitney) | `src/15_rj_pcr.R` + `datos/pcr.R` | **Hecho** |
| `img/rj_glucosa.pdf` (FP/FN como errores I/II, simulación) | `src/16_rj_glucosa.R` + `datos/glucosa.R` | **Hecho** |
| Medias con IC por grupo | — | Pendiente (opcional) |
| Capturas jamovi nuevas (filtros, t, χ²) | — | Pendiente (manual) |

## Preguntas abiertas para el profesor

1. ¿Mantener una única población (`poblacion.omv`) o ampliar `pacientes.omv` de la práctica 1? (propuesta: nueva, por la idea muestra/población).
2. ¿Se mantiene ANOVA/K-W y regresión del curso pasado o se eliminan del todo?
3. Reparto de tiempos: ¿2 h + 2 h en dos días? (marcaría el corte tras la sección 2).
4. Capturas de jamovi: ¿se reutilizan las de S2 o se rehacen con los datos nuevos?
