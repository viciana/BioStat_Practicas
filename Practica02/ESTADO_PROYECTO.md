# Práctica 2 de Bioestadística (2º Medicina): estado del proyecto

> **Repositorio:** https://github.com/viciana/BioStat_Practicas, carpeta
> `Practica02/` (local: `sesiones/BioStat_Practicas/`). La carpeta antigua
> `sesiones/practica02/` quedó como copia y ya no se mantiene.

*Última actualización: 26-10-2026 (sesión de revisión diapositiva a diapositiva; ver §2b). Documento
para retomar el trabajo en otra sesión de Claude: leer `CLAUDE.md`, este
fichero y `guion_practica02.md`.*

## 1. Objetivo

Presentación org-mode → beamer → PDF para 4 h de prácticas de inferencia
(temas 4, 5 y 6 del coordinador: contraste de hipótesis; proporciones,
χ², Yates, Fisher; dos medias independientes/pareadas, paramétricas y no
paramétricas). Mismo método y estilo que `../Practica01` (ver su
`ESTADO_PROYECTO.md`): datos simulados en R en `.omv`, gráficos R con el
script del alumno enlazado en el PDF (`https://epidemos.es/bs2026/`),
`make` regenera todo.

Material del curso anterior: `../../S2/ppt02.org` (+ `imagenes/`, `NewIMG/`).

## 2. Hecho en esta sesión (BORRADOR v0, sin revisar por el profesor)

| Pieza | Fichero | Estado |
|---|---|---|
| Guion (3 niveles: sección › diapositiva › contenido) | `guion_practica02.md` | Propuesta v0, con 4 preguntas abiertas al final |
| Datos: población simulada N = 2000 con filtros `Muestra_grande` (300) y `Muestra_peq` (30 ⊂ grande) | `src/01_simula_poblacion.R` → `datos/poblacion.{csv,omv}` | Hecho (semilla 20261014) |
| Gráfico 100 IC (n = 30, colesterol) | `datos/ic.R` + `src/10_rj_ic.R` → `img/rj_ic.pdf` | Hecho |
| Gráfico p-valor sobre la t (H0: μ = 145, muestra pequeña) | `datos/pvalor.R` + `src/11_rj_pvalor.R` | Hecho |
| Observadas vs esperadas Fumador × Infarto | `datos/chi2.R` + `src/12_rj_chi2.R` | Hecho (ver nota abajo) |
| Pareadas PAS basal/8 sem (pendientes + diferencias) | `datos/pareadas.R` + `src/13_rj_pareadas.R` | Hecho |
| Forest plot: diferencia PAS Placebo−Fármaco con IC (pequeña / grande / población) | `datos/forest.R` + `src/14_rj_forest.R` | Hecho |
| PCR por tabaco: histograma + cajas, t vs Mann-Whitney | `datos/pcr.R` + `src/15_rj_pcr.R` | Hecho |
| Glucosa basal y diabetes: simulación 1000 sanos / 1000 diabéticos, umbral 120, FP = tipo I, FN = tipo II, dos escenarios (media 175 y 140) | `datos/glucosa.R` (autónomo, sin datos) + `src/16_rj_glucosa.R` | Hecho (pág. 18); sustituye las 5 figuras de S2 |
| Árbol de decisión de pruebas (TikZ standalone) | `src/20_arbol_pruebas.tex` → `img/arbol_pruebas.pdf` | Hecho |
| Presentación | `practica02.org` → `practica02.pdf` (47 págs., 6 secciones, Q.01–Q.10) | Borrador; `make clean && make` regenera todo desde cero |
| Build | `Makefile`, `myconfbeamer.org` (copiado de practica01), `.gitignore`, `LICENSE` | Hecho; `make pdf` funciona |

Los scripts `datos/*.R` siguen el patrón de practica01: en Rj usan `data`;
en R descargan `poblacion.omv` de `epidemos.es/bs2026/` (**aún no subido**).

### Variables de `poblacion.omv`
ID, Sexo, Edad, Educa (ordinal), GrupoSang, Fumador, Ejercicio (ordinal), Tratamiento
(Placebo/Fármaco), PAS_basal, PAS_8sem, Mejora (bajada ≥ 10 mmHg),
Colesterol, PCR (lognormal, asimétrica), Dolor (0-10), EfAdverso (raro:
3 % placebo / 9 % fármaco → Fisher), Infarto (asociado a tabaco y edad),
Muestra_grande, Muestra_peq.

**Codificación (25-10):** las categóricas son **enteros con etiquetas**
(jmvReadWrite no sabe escribirlas: `src/omv_enteros.R` retoca el `.omv`
tras `write_omv`). En las dicotómicas **0 = referencia**: Sexo 0 Mujer /
1 Hombre, Tratamiento 0 Placebo / 1 Fármaco, Fumador, Mejora, EfAdverso
e Infarto 0 No / 1 Sí; así la media en jamovi es la proporción de 1.
Ejercicio y Educa (1 Básicos, 2 Medios, 3 Superiores) son ordinales 1-3.
**Educa** se simula al final del script (latente logística en terciles,
~1/3 por nivel) a partir de Edad, Fumador y Ejercicio, para no alterar
las demás variables: edad media 64 / 58 / 51, % fumadores 35 / 26 / 18,
% sedentarios 60 / 47 / 33 (Básicos / Medios / Superiores).

«Verdad» poblacional: bajada PAS 4,1 (placebo) vs 12,4 mmHg (fármaco);
colesterol H 209,7 / M 212,1 (diferencia pequeña → error tipo II);
Infarto: 4,1 % no fumadores vs 17,5 % fumadores (coef. 1,7 tras recalibrar).

Resultados en las muestras (comprobados, para las soluciones):
- Fumador × Infarto: grande 3,8 % vs 17 %, χ² p < 0,001; pequeña p ≈ 0,009 (esperadas < 5).
- Tratamiento × EfAdverso, **grande**: χ² p = 0,037, Yates p = 0,060, Fisher p = 0,058
  → ejemplo perfecto de Q.04 (la decisión cambia según la prueba). En la pequeña:
  16/0 vs 12/2, esperadas ≈ 1 → solo Fisher (p = 0,21).
- Educa × Fumador (Q.05, 3×2): grande χ² p = 0,0014 (% fumadores 42 / 21 / 24;
  en la población 35 / 26 / 18); pequeña p = 0,88, esperadas < 5.
  Sustituye a Ejercicio × Mejora (p = 0,44: Mejora solo depende del tratamiento).
- PAS_8sem por tratamiento: pequeña p = 0,16 (error tipo II), grande p < 0,001.
- Colesterol por sexo: no significativo en ninguna muestra (diferencia real 2,4 mg/dL).
- PCR por fumador (grande): t p = 0,004; Mann-Whitney p = 0,00002.
- PAS basal vs 145: pequeña p = 0,002; media poblacional 151,0.
- % mujeres vs 48 %: pob 47,5 %; ninguna muestra rechaza.

Si se cambia la semilla o el orden de las llamadas a `rbinom/sample` en
`01_simula_poblacion.R`, **todos** estos números cambian.

## 2b. Sesión del 26-10-2026: revisión de las diapositivas 7-21 (PDF ahora 55 págs.)

Se revisó la presentación **en orden**, con el profesor decidiendo cada cambio.
Numeración actual (PDF):

| Pág. | Diapositiva | Qué se hizo |
|---|---|---|
| 7 | Estadística descriptiva frente a inferencial | Texto y tabla reescritos: parámetro poblacional / estadístico muestral / **estimador del parámetro** (no «estimador muestral»); recuadro estimador vs estimación |
| 8 | De la población a la muestra y vuelta | Diagrama TikZ nuevo `src/21_inferencia.tex` → `img/inferencia.pdf` (sustituye la imagen de S2) |
| 10 | De la binomial a la normal: lanzar monedas | NUEVA. Masas de probabilidad (punto + línea) de B(n; 0,5), n = 1, 4, 10, 40, con la normal encima. `datos/binomial.R`. Recuadro «por qué la normal es tan normal» |
| 11 | La curva normal | Curva teórica sin histograma: μ, σ, **puntos de inflexión en μ±σ** (curva coloreada cóncava/convexa + tangentes), áreas 68,3/95,4/99,7 %. `datos/normal.R` |
| 12 | Normal tipificada Z | 3 variables reales (Edad, PAS, Colesterol) y sus Z. `datos/tipifica.R` (sustituye la figura Python) |
| 13 | Z frente a t de Student | Pie reescrito («si σ es desconocida… la referencia que usaremos es la t») |
| 14 | TCL y error estándar | «…sea cual sea la forma de la distribución de la variable original (normal o no normal)» |
| 15 | TCL: población frente a medias muestrales | Fila superior: población (N = 2000) con μ punteada; inferior: densidades de **100 muestras** con n = 3, 9, 27 y rayas de color = media de las medias. Eje X común (PCR recortada a 0-25). `datos/tcl.R` |
| 16-17 | jamovi Demonstrations: *Central Limit Theorem* | NUEVAS, con `capturas/clt_*.png` (instalación del módulo y 3 distribuciones de partida) |
| 18 | Aciertos en 100 muestras de 30 casos con α = 0,05 | Título en una línea, texto sin «La sala vota», gráfico mayor, rótulo con μ y coma decimal |
| 19 | Q.01 Intervalos de confianza | Ahora va **antes** de su resultado |
| 20 | Resultado: IC de Colesterol y Fumador en jamovi | NUEVA, con `capturas/q01_*.png` (panel + tablas pequeña/grande/población) |
| 21 | IC de una proporción en jamovi | NUEVA (sustituye a la antigua Q.01 y a las capturas de S2): Fumador y **Ejercicio**; recuadro azul = proporción poblacional, rojos = IC de las muestras, con texto de comprobación. `capturas/ic_prop_*.png` |

Ficheros nuevos de código: `datos/{binomial,normal,tipifica,tcl}.R` con sus
lanzadores `src/{22_rj_binomial,17_rj_normal,18_rj_tipifica,19_rj_tcl}.R`
y `src/21_inferencia.tex`; todos en el `Makefile`. Las capturas de jamovi
están en `capturas/` (nombres sin espacios; PNG con recuadros dibujados, los
originales se borraron). **El `Makefile` ya recompila el PDF si cambia una
captura.** Se versionan también `src/NormalesNormalziadas.py` y
`src/normal_standardization.svg` (propuesta inicial en Python de la figura
de normales estandarizadas, ya sustituida por `datos/tipifica.R`; se puede borrar).

**Decisiones del profesor a recordar:** términos «estadístico muestral»,
«estimador del parámetro», «estimación»; las simulaciones usan la población
simulada (N = 2000, no 3000); en jamovi se usa Ejercicio en vez de GrupoSang
para el IC de proporciones; Q.01 se pregunta antes de mostrar resultados.

## 3. Pendiente / ideas para la próxima sesión

**Seguir la revisión desde la pág. 22 (sección «Contraste de hipótesis»)**, en este orden:
1. Contraste de hipótesis (págs. 22-30): p-valor (`rj_pvalor`, el área apenas
   se ve: probar H0: μ = 148), errores I/II, árbol de pruebas, Q.02
   (el guion decía 150 mmHg y la diapositiva 145: unificar).
2. Comparación de proporciones y de medias (págs. 31-52).
3. Capturas de jamovi **aún provisionales** (de `../../S2`, otros datos):
   filtros `Muestra_*` (no existe `img/c01_filtros.png`), t de una muestra,
   tabla 2×2, tabla N×M, dos muestras independientes, pareadas, ANOVA.
   Faltan también capturas de Mann-Whitney y de Fisher/Yates.
4. Diapositivas prometidas en el guion y aún sin hacer: Wilcoxon de rangos
   con signo (propia), McNemar, residuos en tablas N×M, prueba binomial,
   medias con IC por grupo (opcional).
5. Maquetación: tabla de variables (diapositiva 5, columna «Variable» se parte),
   texto `Muestra_peq == 1` en la diapositiva de filtros; el texto de la
   diapositiva 21 (IC proporciones) queda justo de espacio.
6. Subir `poblacion.omv` y los `datos/*.R` a `epidemos.es/bs2026/` (los
   enlaces del PDF aún no funcionan: `ic.R`, `normal.R`, `tcl.R`, `binomial.R`,
   `tipifica.R`, `inferencia.tex`, etc.).
7. Preguntas abiertas del guion (ANOVA/K-W, reparto 2 h + 2 h, regresión) y
   actualizar `guion_practica02.md` con la nueva sección 2 (Normal, TCL e IC) y
   las diapositivas añadidas.

**Acordado antes (14-10):** el borrador «está bastante bien»; las capturas de
jamovi se rehacen en otra sesión (en curso: se han rehecho las de IC).

## 4. Nota sobre CLAUDE.md

La sección «Objetivo inicial» de `CLAUDE.md` (páginas 29-31 de
`anterior/ppt01.pdf`, asimetría y curtosis) se refiere a
`../../S1/anterior/ppt01.pdf`, la presentación de la **práctica 1** del curso
pasado; ese piloto ya se hizo en `../Practica01` (`rj_asimetria`,
`rj_curtosis`). Para la práctica 2 la referencia es `../../S2/ppt02.org`.
