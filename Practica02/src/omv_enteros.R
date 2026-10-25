# ---------------------------------------------------------------------
# omv_enteros.R
# Variables categóricas de jamovi ENTERAS con etiquetas (como las que
# quedan al importar un CSV y etiquetar los códigos en jamovi): por
# ejemplo Infarto = 0 «No» / 1 «Sí». jamovi las trata como nominales,
# pero su valor subyacente sigue siendo el entero, de modo que en
# Descriptivas dan media (= proporción de 1) y en las fórmulas
# `Infarto == 1` usa el código.
#
# jmvReadWrite (0.4.x) no sabe escribirlas: un factor con etiquetas no
# numéricas lo guarda como Texto (códigos 0, 1, 2… según el orden de los
# niveles) y se pierde el valor original. Solución (la misma que en
# ../Practica01/src/07_soluciones.R): escribir las columnas como enteros
# y retocar después metadata.json y xdata.json dentro del .omv.
#
# Uso:  source("src/omv_enteros.R")
#       write_omv(df, fic, frcWrt = TRUE)       # columnas como enteros
#       etiqueta_enteros(fic, list(
#         Infarto = c("0" = "No", "1" = "Sí"),  # el orden del vector es
#         Sexo    = c("1" = "Hombre", "2" = "Mujer")),  # el de los niveles
#         ordinales = "Ejercicio")
# ---------------------------------------------------------------------
library(jsonlite)

etiqueta_enteros <- function(fic, etiquetas, ordinales = character(0)) {
  tmp <- tempfile(); dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE))
  unzip(fic, exdir = tmp)
  mta <- read_json(file.path(tmp, "metadata.json"))
  xda <- read_json(file.path(tmp, "xdata.json"))
  if (length(xda) == 0) xda <- setNames(list(), character(0))

  campos <- mta$dataSet$fields
  nombre <- vapply(campos, `[[`, "", "name")
  for (v in names(etiquetas)) {
    i <- which(nombre == v)
    if (length(i) != 1) stop("No existe la columna ", v, " en ", fic)
    if (campos[[i]]$dataType != "Integer")
      stop(v, ": debe escribirse como entero (no como factor ni decimal)")
    campos[[i]]$measureType <- if (v %in% ordinales) "Ordinal" else "Nominal"
    campos[[i]]$type <- "integer"
    campos[[i]]$trimLevels <- TRUE
    eti <- etiquetas[[v]]
    xda[[v]] <- list(labels = lapply(seq_along(eti), \(k)
      list(as.integer(names(eti)[k]), unname(eti[k]), names(eti)[k], FALSE)))
  }
  mta$dataSet$fields <- campos
  write_json(mta, file.path(tmp, "metadata.json"), auto_unbox = TRUE,
             null = "null", digits = NA)
  write_json(xda, file.path(tmp, "xdata.json"), auto_unbox = TRUE)

  ficheros <- c("meta", setdiff(list.files(tmp, recursive = TRUE), "meta"))
  fic_abs <- normalizePath(fic)
  invisible(file.remove(fic_abs))
  old <- setwd(tmp); on.exit(setwd(old), add = TRUE, after = FALSE)
  zip(fic_abs, ficheros, flags = "-q -X")
  invisible(fic)
}
