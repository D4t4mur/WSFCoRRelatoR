#' function to extract all the built up area pixels from world settlement footprint raster
#' into new raster

#' @param wsf_raster raster with world settlement footprint data
#' @param boundary_polygon vector file with optional boundary units
#' @return total built-up area as sf-object
#' @export

builtuparea <- function(wsf_raster, boundary_polygon) {

  library(sf) # shapefiles and geopackages
  library(terra) # rasters
  library(dplyr) # data manipulation

  data <- if (inherits(wsf_raster, "SpatRaster")) wsf_raster else rast(wsf_raster)

  if (!hasValues(data)) stop("Raster contains no values.")
  if (!inherits(boundary_polygon, "sf")) stop("Boundary has to be a sf-object.")

  boundary <- st_transform(boundary_polygon, crs(data))
  data_crop <- crop(data, vect(boundary))

  mask <- data_crop
  values(mask)[values(data_crop) != 255] <- NA
  mask <- classify(data_crop, rcl = matrix(c(-Inf, 254, NA), ncol = 3, byrow = TRUE))


  boundary_mask <- mask(mask, boundary)
  builtup <- as.polygons(boundary_mask, dissolve = TRUE, na.rm = TRUE)
  builtup_sf <- st_as_sf(builtup)

  return(builtup_sf)
}


#' #' Extract built-up area polygons from a World Settlement Footprint (WSF) raster
#' #'
#' #' This function identifies and extracts all built-up area pixels (value == 255)
#' #' from a WSF raster as polygons. Optionally, the result can be clipped to a given boundary polygon.
#' #'
#' #' @param wsf_raster A `SpatRaster` object or a file path to a raster containing WSF data.
#' #' @param boundary_polygon Optional `sf` polygon (e.g., administrative boundary) for clipping the result.
#' #' @return An `sf` object containing built-up area polygons.
#' #' @export
#' builtuparea <- function(wsf_raster, boundary_polygon = NULL) {
#'
#'   # Laden der benötigten Bibliotheken
#'   library(sf)
#'   library(terra)
#'   library(dplyr)
#'
#'   # Falls der Input ein Pfad ist, das Raster laden
#'   data <- if (inherits(wsf_raster, "SpatRaster")) wsf_raster else rast(wsf_raster)
#'
#'   # Überprüfen, ob Raster Daten enthält
#'   if (!hasValues(data)) stop("⚠️ Das Raster enthält keine Werte.")
#'
#'   # Maskiere alle Pixel, die nicht 255 sind (d.h. nicht bebaut)
#'   built_mask <- data
#'   values(built_mask)[values(data) != 255] <- NA  # Setze alle Pixel, die nicht 255 sind, auf NA
#'
#'   # Überprüfe, ob es Pixel mit dem Wert 255 gibt
#'   if (sum(!is.na(values(built_mask))) == 0) stop("⚠️ Keine '255' Pixel im Raster gefunden.")
#'
#'   # Extrahiere die bebaute Fläche als Polygone
#'   builtup <- as.polygons(built_mask, dissolve = TRUE, na.rm = TRUE)
#'   builtup <- st_as_sf(builtup)
#'
#'   # Optionales Clipping an einem Boundary
#'   if (!is.null(boundary_polygon)) {
#'     boundary_polygon <- st_transform(boundary_polygon, crs(data))
#'     builtup <- st_intersection(builtup, boundary_polygon)
#'   }
#'
#'   return(builtup)
#' }
