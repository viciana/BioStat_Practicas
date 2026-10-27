# Práctica 2 de Bioestadística (2º Medicina): estado del proyecto

> **Repositorio:** https://github.com/viciana/BioStat_Practicas, carpeta
> `Practica02/` (local: `sesiones/BioStat_Practicas/`). La carpeta antigua
> `sesiones/practica02/` quedó como copia y ya no se mantiene.

*Última actualización: 27-10-2026, tarde (secciones de contraste, proporciones y medias rehechas y 5 capturas de jamovi integradas; ver §2c y §3). Documento
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
- PCR por fumador (grande): t de Student p = 0,0003 (Welch p = 0,004; jamovi avisa de que Levene es significativo); Mann-Whitney p = 0,00002.
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

## 2c. Sesión del 27-10-2026: secciones 3-6 rehechas para jamovi (PDF ahora 78 págs.)

Reescritas desde la pág. 22 siguiendo los temas 4, 5 y 6 del coordinador,
con ejemplos sobre `poblacion_filtros.omv`. Todas las cifras de las
soluciones se han comprobado **con el propio motor de jamovi** (`jmv` de la
instalación flatpak, ver más abajo).

**Datos**
- `poblacion_filtros.omv` (el fichero de clase que creó el profesor a mano)
  ahora lo genera `src/02_filtros.R` con `anade_filtros()` (en
  `src/omv_enteros.R`): mismos filtros, fórmulas y descripciones
  (`Filtrar 1`: `Muestra_grande == 1`, «Muestra de 300»; `Filtrar 2`:
  `Muestra_peq == 1`, «Muestra de 30»; inactivos). Comprobado columna a
  columna frente al original. **Falta abrirlo en jamovi para confirmar.**
  `make clean` lo borra y `make datos` lo regenera.
- Nuevas variables `HTA_basal` y `HTA_8sem` (PAS ≥ 140, No/Sí) para McNemar.
  Son deterministas: el resto de los datos no cambia (comprobado).

**Soluciones generadas**: `src/30_resultados.R` → `img/res_*.tex` (tablas
booktabs con punto decimal, como jamovi), que el `.org` inserta con `\input`.
Así los números de los «Resultado Q.xx» no se escriben a mano.

**Cambios en 1-2**: tabla de variables en LaTeX (ya no se parte) con HTA;
diapositiva de filtros explicada con `Filtrar 1/2`; «Precisión» ya no
incluye el p-valor; Z frente a t con figura propia (`datos/zt.R`, sustituye
`S2/imagenes/tStudenZ.png`); Q.01 dice qué filtro activar; nota de que el IC
de proporciones de jamovi es exacto (Clopper-Pearson).

**Sección 3 (tema 4)**: juicio; **cinco pasos** con H0: μ = 148 (ya
unificado: figura `rj_pvalor` y Q.02 usan 148; pequeña p = 0,100 → error
tipo II, grande p < 0,001); **bilateral/unilateral** (p unilateral 0,050, en
el filo); **contraste ⇔ IC**; errores I/II como tabla LaTeX (sustituye la
imagen de S2); glucosa; significación vs relevancia (ejemplo corregido: 8,3
mmHg, IC 4,9 a 11,8); **tipos de pruebas**; árbol ampliado con pruebas de una
muestra; **mapa de menús de jamovi**; t de una muestra y binomial; Q.02 + resultado.

**Sección 4 (tema 5)**: tablas de contingencia; observadas/esperadas;
χ² y condiciones; **Yates**; **Fisher con ejemplo resuelto** (3 tablas
posibles, p = 0,209); cuándo cada una; medidas de efecto; panel de jamovi;
Q.03-Q.05 con resultado; **residuos tipificados** en N×M; **McNemar** (Q.06).

**Sección 5 (tema 6)**: independientes vs pareadas; paramétricas vs no
paramétricas (ejemplo de rangos); supuestos; panel; Q.07 (PAS, con el
forest plot), Q.08 (colesterol), Q.09 (PCR y Dolor), **Wilcoxon de rangos con
signo** (propia), panel pareadas, Q.10 (incluye el p «mal» calculado como
independientes); ANOVA/K-W «para saber más» con datos propios (PAS por Educa:
p = 0,056 / 0,059). Q.11 con ejemplo de redacción.

**Detalles de jamovi comprobados con `jmv`** (importantes para el profesor):
- Tablas 2×2: el **RR de jamovi usa la primera columna (No) como suceso**:
  Fumador × Infarto da RR = 1,16 (riesgo de *no* infarto), no 4,52. OR (5,24) y
  diferencia (0,133) salen bien. Explicado en las diapositivas.
- t de una muestra: jamovi da el IC de la **diferencia** μ − 148, no el de μ.
- PCR: jamovi marca Levene significativo (nota ᵃ) → Welch.

Etiquetas de jamovi en español tomadas de su traducción (`es.json` del
flatpak) y escritas con la macro `\jmv{}` (sans serif azul). Para volver a
comprobar resultados con el motor real de jamovi:
`flatpak run --command=/app/lib/R/bin/Rscript org.jamovi.jamovi script.R`
con `.libPaths("/app/lib/jamovi/modules/jmv/R")` y `LANG=C.UTF-8`.

## 3. Pendiente / ideas para la próxima sesión

**Para retomar (28-10):** el profesor hará las 2 capturas opcionales
(McNemar y residuos, detalle en el punto 1) y se integran; después, revisión
diapositiva a diapositiva de las págs. 22-78 (punto 2).


1. **Capturas de jamovi**: las 5 principales ya están integradas (27-10):
   `filtros.png` (pág. 6), `t1m_panel.png` (34), `tc_panel.png` (45),
   `tis_panel.png` (60) y `tps_panel_30.png` (71, muestra pequeña; la de la
   grande, `tps_panel.png`, no se usa). Textos ajustados a las etiquetas reales
   de jamovi («Rangos de Wilcoxon», «Descriptivas», «Gráfica Q-Q»…). Los residuos
   de tablas N×M están en la sección **Pruebas post hoc**, no en Celdas (corregido).
   **Opcionales pedidas** (irían en «Proporciones pareadas: McNemar» / «Resultado Q.06»
   y en «Tablas N×M» / «Resultado Q.05»):
   - `mcnemar_filtros.png` + `mcnemar_panel.png`: Filtrar 1 + nuevo filtro
     `Tratamiento == 1`; Frecuencias → Tablas de Contingencia → Muestras Pareadas,
     HTA_basal × HTA_8sem, χ² y χ² con corrección, % de fila. Debe dar 25/0/49/70,
     χ² = 49,0 (corregido 47,0), p < .001, N = 144.
   - `tc_residuos.png`: Filtrar 1; Educa × Fumador, Frecuencias esperadas, % fila,
     Pruebas post hoc → Residuos tipificados (ajuste de Pearson), resaltar > 1,96.
     Debe dar χ² = 13,18, gl 2, p = .001; residuos (Sí) 3,60 / −2,10 / −1,62.
2. Revisar con el profesor las diapositivas 22-78 (contenido nuevo).
3. Abrir `poblacion_filtros.omv` generado en jamovi y comprobar filtros y etiquetas.
4. Subir `poblacion_filtros.omv`, `poblacion.omv` y los `datos/*.R` a
   `epidemos.es/bs2026/` (los enlaces del PDF aún no funcionan; nuevo: `zt.R`).
5. Tiempo: 78 páginas para 4 h; si sobra, candidatas a recortar: glucosa,
   ANOVA, Wilcoxon de rangos con signo (concepto) o la de tipos de pruebas.
6. Actualizar `guion_practica02.md` (sigue reflejando el borrador v0).
7. (Hecho) Borrada la captura del terminal. El `Makefile` ignora los PNG con
   espacios en el nombre.
8. `src/NormalesNormalziadas.py` y `src/normal_standardization.svg` se pueden borrar.

## 4. Nota sobre CLAUDE.md

La sección «Objetivo inicial» de `CLAUDE.md` (páginas 29-31 de
`anterior/ppt01.pdf`, asimetría y curtosis) se refiere a
`../../S1/anterior/ppt01.pdf`, la presentación de la **práctica 1** del curso
pasado; ese piloto ya se hizo en `../Practica01` (`rj_asimetria`,
`rj_curtosis`). Para la práctica 2 la referencia es `../../S2/ppt02.org`.
