# Prácticas de Bioestadística con JAMOVI (2º de Medicina)

Presentaciones (org-mode → beamer → PDF) de las prácticas de
Bioestadística de 2º de Medicina, curso 2026-2027 (Fco. Viciana,
Universidad de Sevilla). Cada práctica está en su carpeta, con su propio
`Makefile`, y se regenera desde cero (datos simulados, gráficos y PDF)
con `make` dentro de ella.

| Carpeta | Práctica | Estado |
|---------|----------|--------|
| [`Practica01/`](Practica01/) | 1ª: introducción a JAMOVI, estadística descriptiva, correlación y regresión | Terminada (76 págs.) |
| [`Practica02/`](Practica02/) | 2ª: inferencia — contraste de hipótesis, proporciones (χ², Yates, Fisher), comparación de dos medias | Borrador v0 |

```sh
cd Practica01 && make     # o: cd Practica02 && make
```

Requisitos y detalles de cada práctica en su `README.md` o
`ESTADO_PROYECTO.md`.

Datos y scripts para los alumnos: <https://epidemos.es/bs2026/>.

## Licencia

Creative Commons Reconocimiento 4.0 Internacional (CC BY 4.0), salvo el
material de terceros indicado en cada práctica. Texto completo en
[`LICENSE`](LICENSE).
