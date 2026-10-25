# Práctica 2 de Bioestadística (2º Medicina): estado del proyecto

> **Repositorio:** https://github.com/viciana/BioStat_Practicas, carpeta
> `Practica02/` (local: `sesiones/BioStat_Practicas/`). La carpeta antigua
> `sesiones/practica02/` quedó como copia y ya no se mantiene.

*Última actualización: 14-10-2026 (sesión corta, 14:15-14:30). Documento
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

## 3. Pendiente / ideas para la próxima sesión

1. **Revisión del guion por el profesor** (preguntas abiertas en
   `guion_practica02.md`) antes de seguir puliendo diapositivas.
2. ~~Calibrar la simulación~~ (hecho 14:25: efecto del tabaco sobre
   infarto subido de 0,9 a 1,7). Decidir si Q.04 debe usar la muestra
   grande (donde χ²/Yates/Fisher discrepan) como pregunta principal.
3. **Capturas de jamovi**: el borrador usa provisionalmente las de
   `../../S2` (otros datos) vía la macro `\captura` (muestra un recuadro
   «Captura pendiente» si falta el fichero, p. ej. `img/c01_filtros.png`).
   Rehacer con `poblacion.omv` (filtros, t independiente y pareada,
   Mann-Whitney, tablas 2×2 con Fisher/Yates).
4. Gráficos R pendientes: medias con IC por grupo (opcional);
   en `rj_pvalor` el área del p-valor apenas se ve (t = 3,4): quizá usar
   H0: μ = 148 para que se vea.
5. Ajustes de maquetación: tabla de variables (columna Variable se parte),
   texto `Muestra_peq == 1` en la diapositiva de filtros.
6. Subir `poblacion.omv` y los `datos/*.R` a `epidemos.es/bs2026/` cuando
   estén aprobados (o decidir carpeta nueva, p. ej. `bs2026p2`).
7. ~~Repositorio git~~ (hecho 14-10): vive en `BioStat_Practicas/Practica02/`
   (GitHub `viciana/BioStat_Practicas`, junto a `Practica01/`).

**Acordado con el profesor (14-10, final de sesión):** el borrador
«está bastante bien», lo repasará con tranquilidad; las capturas de
jamovi se dejan para otra sesión.

## 4. Nota sobre CLAUDE.md

La sección «Objetivo inicial» de `CLAUDE.md` (páginas 29-31 de
`anterior/ppt01.pdf`, asimetría y curtosis) se refiere a
`../../S1/anterior/ppt01.pdf`, la presentación de la **práctica 1** del curso
pasado; ese piloto ya se hizo en `../Practica01` (`rj_asimetria`,
`rj_curtosis`). Para la práctica 2 la referencia es `../../S2/ppt02.org`.
