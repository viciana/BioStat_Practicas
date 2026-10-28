# Guion — 2ª Práctica de Bioestadística: Inferencia estadística con JAMOVI

*v1 · 28-10-2026 · 2º Medicina, Grupo B · 4 horas · `practica02.pdf` (81 págs.)*

Temas del coordinador: **(4)** contraste de hipótesis y tipos de pruebas;
**(5)** comparación de proporciones: χ², Fisher, Yates, tablas de
contingencia; **(6)** comparación de dos medias independientes y
dependientes: pruebas paramétricas y no paramétricas.

Material de partida: `../../S2/ppt02.org` (curso 2025-26). Formato y
herramientas: los de `../Practica01` (org → beamer, datos `.omv`
simulados en R, gráficos R con su script enlazado en el PDF).

## Decisiones de diseño

- **Una población conocida + dos muestras**: `poblacion.omv` (N = 2000,
  semilla 20261014) con dos filtros ya creados: `Filtrar 1` = muestra
  grande (n = 300) y `Filtrar 2` = muestra pequeña (n = 30, dentro de la
  grande). El alumno hace inferencia con la muestra y **contrasta con la
  verdad** poblacional (quitando el filtro).
- Hilo conductor: **ensayo clínico de un suplemento dietético frente a
  placebo** en adultos con riesgo cardiovascular. Da de forma natural
  medias independientes (PAS a 8 semanas por grupo), pareadas (PAS basal /
  8 semanas), proporciones independientes (Fumador × Infarto, efecto
  adverso) y pareadas (Sobrepeso basal / 8 semanas, McNemar).
- **Punto decimal** en todo el material, como jamovi.
- Etiquetas de jamovi en castellano tal como aparecen en el programa
  (`\jmv{}` en las diapositivas); resultados numéricos verificados con el
  propio `jmv` de jamovi.
- **Se recorta** respecto al curso pasado: binomial (repaso), ANOVA/K-W
  (1 diapositiva «para saber más»), regresión (ya vista en la práctica 1).
- **Se amplía**: lógica del contraste (juicio con jurado), p-valor, errores
  α/β y potencia, elección de la prueba (árbol), Yates y Fisher, residuos,
  McNemar, no paramétricas.

## Estructura (sección › diapositiva › contenido)

### 1. Presentación: datos y objetivos (≈ 10 min)
- **Objetivos**; **Los datos: `poblacion.omv`** (diccionario de variables)
- **Muestra y población: los filtros de jamovi** (captura `filtros.png`)
- Descriptiva frente a inferencial; de la población a la muestra y vuelta

### 2. Normal, TCL e intervalos de confianza (≈ 40 min)
- De la binomial a la normal; normal tipificada Z; Z frente a t (`rj_zt.pdf`)
- **TCL y error estándar** (módulo *Demonstrations* de jamovi, tres distribuciones)
- **100 intervalos de confianza** (`rj_ic.pdf`): interpretación del 95 %
- **Q.01** IC del colesterol y de la proporción de fumadores: pequeña / grande / población
- IC de una proporción en jamovi (Clopper-Pearson)

### 3. Contraste de hipótesis y tipos de pruebas — tema 4 (≈ 50 min)
- **Lógica del contraste: un juicio con jurado** (defensa = H₀, fiscal = H₁,
  jurado = α, reconstrucción = estadístico, coartada = p-valor, veredicto)
- **Los cinco pasos** (H₀: μ = 148); **el p-valor dibujado** (`rj_pvalor.pdf`)
- Bilateral y unilateral; contraste ⇔ IC
- **Errores tipo I y II, potencia** (tabla del juicio) y **glucosa/diabetes**:
  matriz de errores + curvas SANO / ENFERMO (`rj_glucosa.pdf`)
- Significación ≠ relevancia clínica
- **Tipos de pruebas**, **árbol de decisión** (TikZ) y mapa de menús de jamovi
- **Comparar con un valor de referencia** (captura `t1m_panel.png`):
  t para una muestra y prueba de proporciones
- **Q.02** ¿PAS basal media = 148? (pequeña p = 0.10: error tipo II; grande
  la rechaza); ¿48 % de mujeres? (binomial)

### 4. Comparando proporciones en tablas con dos variables: tablas de contingencia — tema 5 (≈ 65 min)
- Tablas de contingencia; frecuencias observadas y esperadas
- **χ² de Pearson**, **Yates**, **Fisher** (ejemplo resuelto) y cuándo usar cada uno
- **Medidas de efecto**: diferencia de proporciones, RR, OR con IC (aviso:
  el RR de jamovi toma la primera columna como suceso)
- **Tablas de contingencia en jamovi** (captura `tc_panel.png`)
- **Q.03** Fumador × Infarto (grande: χ² = 15.5, p < 0.001; OR = 5.24)
- **Q.04** Efecto adverso en la pequeña: χ², Yates o Fisher
- **Tablas N×M**: grados de libertad y residuos (en *Pruebas post hoc*);
  **tres tipos de residuos** (no tipificado, Pearson, tipificado)
- **Q.05** Educa × Fumador (captura `tc_residuos.png`); pequeña con esperadas < 5
- **Proporciones pareadas: McNemar** con Sobrepeso basal × 8 semanas
  (captura `mcnemar_panel.png`; grande χ² = 12.46)
- **Q.06** ¿Baja la proporción con sobrepeso? Pequeña, grande y por grupo

### 5. Comparación de dos medias — tema 6 (≈ 60 min)
- Independientes y pareadas; paramétricas y no paramétricas (rangos)
- **Condiciones de la t**: normalidad (Shapiro-Wilk, Q-Q), Levene → Welch
- **Dos muestras independientes en jamovi** (captura `tis_panel.png`)
- **Q.07** ¿Funciona el suplemento? PAS a 8 semanas (grande: t = 4.81,
  dif. 8.35, IC 4.93–11.8) y diagrama de bosque (`rj_forest.pdf`)
- **Q.08** Colesterol y sexo: diferencia real pequeña → error tipo II con n = 30
- **U de Mann-Whitney**; PCR muy asimétrica (`rj_pcr.pdf`)
- **Q.09** PCR y tabaco (Welch, p = 0.004); dolor y tratamiento
- **Pareadas**: gráfico de pendientes (`rj_pareadas.pdf`), Wilcoxon de rangos
  con signo, captura `tps_panel_30.png`
- **Q.10** ¿Baja la PAS? En cada grupo (filtro `Tratamiento == 1`);
  pareada frente a independiente
- *(Para saber más)* más de dos grupos: ANOVA y Kruskal-Wallis

### 6. Resumen (≈ 15 min)
- **Tabla resumen: qué prueba usar**
- **Q.11** Redactar los resultados del ensayo + ejemplo de redacción
- Datos y scripts R en `epidemos.es/bs2026/`

## Ficheros

| Fichero | Script | Estado |
|---|---|---|
| `datos/poblacion.csv`, `poblacion_base.omv` | `src/01_simula_poblacion.R` | Hecho |
| `datos/poblacion.omv` (con filtros, el de clase) | `src/02_filtros.R` + `src/omv_enteros.R` | Hecho, subido |
| Tablas de resultados `img/res_*.tex` | `src/30_resultados.R` | Hecho |
| `img/rj_ic.pdf`, `rj_pvalor.pdf`, `rj_chi2.pdf`, `rj_pareadas.pdf`, `rj_forest.pdf`, `rj_pcr.pdf`, `rj_zt.pdf`, `rj_glucosa.pdf`… | `src/1x_rj_*.R` + `datos/*.R` | Hecho, subidos |
| Matriz de errores | `src/matriz_errores.{pdf,svg}` (de S2) | Hecho |
| Árbol de decisión (TikZ) | `src/20_arbol_pruebas.tex` | Hecho |
| Capturas jamovi | `capturas/*.png` (filtros, t1m, tc, tc_residuos, mcnemar, tis, tps_30) | Hecho |

## Pendiente

1. Revisión con el profesor de las diapositivas 22-81.
2. Duración: 81 páginas para 4 h; valorar recortes (candidatas: repaso de
   binomial/normal, «Tipos de pruebas» frente al árbol, segunda diapositiva
   de resultados de Q.05/Q.06, ANOVA).
3. Corte si se imparte en 2 + 2 h: tras la sección 3 (contraste).
