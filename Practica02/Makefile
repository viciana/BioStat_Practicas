# Práctica 2 de Bioestadística (2º Medicina): Inferencia estadística con JAMOVI
# BORRADOR.  Ejecutar desde esta carpeta:
#   make          -> todo (datos, gráficos y practica02.pdf)
#   make datos    -> datos/poblacion.{csv,omv}
#   make graficos -> img/*.pdf
#   make pdf      -> practica02.pdf (org -> beamer, Emacs en modo batch)
#   make clean    -> borra todo lo generado

$(shell mkdir -p img)

EXPORTA = emacs --batch $< --eval "(progn (require 'ox-beamer) (org-beamer-export-to-pdf))"

all: datos graficos pdf

## Datos -----------------------------------------------------------------
datos/poblacion.csv datos/poblacion.omv: src/01_simula_poblacion.R
	Rscript $<

datos: datos/poblacion.omv

## Gráficos (script de alumno datos/X.R + lanzador src/NN_rj_X.R) ---------
img/rj_ic.pdf: src/10_rj_ic.R datos/ic.R datos/poblacion.omv
	Rscript $<
img/rj_pvalor.pdf: src/11_rj_pvalor.R datos/pvalor.R datos/poblacion.omv
	Rscript $<
img/rj_chi2.pdf: src/12_rj_chi2.R datos/chi2.R datos/poblacion.omv
	Rscript $<
img/rj_pareadas.pdf: src/13_rj_pareadas.R datos/pareadas.R datos/poblacion.omv
	Rscript $<
img/rj_forest.pdf: src/14_rj_forest.R datos/forest.R datos/poblacion.omv
	Rscript $<
img/rj_pcr.pdf: src/15_rj_pcr.R datos/pcr.R datos/poblacion.omv
	Rscript $<
img/rj_glucosa.pdf: src/16_rj_glucosa.R datos/glucosa.R
	Rscript $<

## Figuras LaTeX independientes (standalone; TikZ choca con ctable)
STANDALONE = d=$$(mktemp -d) && \
	pdflatex -interaction=nonstopmode -halt-on-error -output-directory=$$d $< >/dev/null && \
	cp $$d/$(basename $(notdir $<)).pdf $@ && rm -r $$d
img/arbol_pruebas.pdf: src/20_arbol_pruebas.tex
	$(STANDALONE)

GRAFICOS = img/rj_ic.pdf img/rj_pvalor.pdf img/rj_chi2.pdf img/rj_pareadas.pdf \
           img/rj_forest.pdf img/rj_pcr.pdf img/rj_glucosa.pdf \
           img/arbol_pruebas.pdf
graficos: $(GRAFICOS)

## Presentación ------------------------------------------------------------
practica02.pdf: practica02.org myconfbeamer.org $(GRAFICOS)
	$(EXPORTA)

pdf: practica02.pdf

clean:
	rm -rf img practica02.pdf practica02.tex datos/*.csv datos/*.omv

.PHONY: all datos graficos pdf clean
