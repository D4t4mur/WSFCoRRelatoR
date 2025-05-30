#' wsfcalc()
#'
#' function to calculate mean wsf value for a raster
#' based on boundary polygon

#' @param wsf_raster raster with world settlement footprint
#' @param boundary_polygon vector file with boundary units
#' @return mean value for world settlement footprint in %
#' @export

wsfcalc <- function(wsf_raster, boundary_polygon) {

  library(sf) # for shapefiles and geopackages
  library(terra) # for rasters
  library(exactextractr) # for accurate raster extraction with polygons

  data <- if (inherits(wsf_raster, "SpatRaster")) wsf_raster else rast(wsf_raster)

  if (!hasValues(data)) stop("Raster contains no values.")
  if (!inherits(boundary_polygon, "sf")) stop("Boundary has to be a sf-object.")

  boundary <- st_transform(boundary_polygon, crs(data))
  data_crop <- crop(data, vect(boundary))

  wsf <- exact_extract(data_crop, boundary, fun = 'mean') %>% round(3)

  return(wsf)
}
