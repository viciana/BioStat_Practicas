# Práctica 2 de Bioestadística (2º Medicina): Inferencia estadística con JAMOVI
# BORRADOR.  Ejecutar desde esta carpeta:
#   make          -> todo (datos, gráficos y practica02.pdf)
#   make datos    -> datos/poblacion.csv y datos/poblacion.omv (con filtros)
#   make resultados -> img/res_*.tex (tablas de soluciones)
#   make graficos -> img/*.pdf
#   make pdf      -> practica02.pdf (org -> beamer, Emacs en modo batch)
#   make clean    -> borra todo lo generado

$(shell mkdir -p img)

EXPORTA = emacs --batch $< --eval "(progn (require 'ox-beamer) (org-beamer-export-to-pdf))"

all: datos graficos resultados pdf

## Datos -----------------------------------------------------------------
datos/poblacion.csv datos/poblacion_base.omv: src/01_simula_poblacion.R
	Rscript $<

datos/poblacion.omv: src/02_filtros.R src/omv_enteros.R datos/poblacion_base.omv
	Rscript $<

datos: datos/poblacion.omv

## Tablas de soluciones (img/res_*.tex, las escribe un único script) ------
img/res_q02_t.tex: src/30_resultados.R src/estilo_jmv.R datos/poblacion.omv
	Rscript $<

resultados: img/res_q02_t.tex

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
img/rj_normal.pdf: src/17_rj_normal.R datos/normal.R
	Rscript $<
img/rj_tipifica.pdf: src/18_rj_tipifica.R datos/tipifica.R datos/poblacion.omv
	Rscript $<
img/rj_binomial.pdf: src/22_rj_binomial.R datos/binomial.R
	Rscript $<
img/rj_tcl.pdf: src/19_rj_tcl.R datos/tcl.R datos/poblacion.omv
	Rscript $<
img/rj_zt.pdf: src/23_rj_zt.R datos/zt.R
	Rscript $<

## Figuras LaTeX independientes (standalone; TikZ choca con ctable)
STANDALONE = d=$$(mktemp -d) && \
	pdflatex -interaction=nonstopmode -halt-on-error -output-directory=$$d $< >/dev/null && \
	cp $$d/$(basename $(notdir $<)).pdf $@ && rm -r $$d
img/arbol_pruebas.pdf: src/20_arbol_pruebas.tex
	$(STANDALONE)
img/inferencia.pdf: src/21_inferencia.tex
	$(STANDALONE)

GRAFICOS = img/rj_ic.pdf img/rj_pvalor.pdf img/rj_chi2.pdf img/rj_pareadas.pdf \
           img/rj_forest.pdf img/rj_pcr.pdf img/rj_glucosa.pdf \
           img/rj_binomial.pdf img/rj_normal.pdf img/rj_tipifica.pdf img/rj_tcl.pdf \
           img/rj_zt.pdf \
           img/arbol_pruebas.pdf img/inferencia.pdf
graficos: $(GRAFICOS)

## Presentación ------------------------------------------------------------
# Capturas de jamovi (se ignoran los nombres con espacios, que rompen make)
CAPTURAS = $(shell find capturas -name "*.png" ! -name "* *")
practica02.pdf: practica02.org myconfbeamer.org $(GRAFICOS) img/res_q02_t.tex \
                $(CAPTURAS)
	$(EXPORTA)

pdf: practica02.pdf

clean:
	rm -rf img practica02.pdf practica02.tex datos/*.csv datos/*.omv

.PHONY: all datos graficos resultados pdf clean
