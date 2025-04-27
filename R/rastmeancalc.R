#' rastmeancalc()
#'
#' function to calculate mean value for a raster
#' based on boundary polygon

#' @param raster raster with random data
#' @param boundary_polygon vector file with boundary units
#' @return mean value for raster values
#' @export

rastmeancalc <- function(raster, boundary_polygon) {

  library(sf) # shapefiles and geopackages
  library(terra) # rasters
  library(exactextractr) # for accurate raster extraction with polygons

  data <- if (inherits(raster, "SpatRaster")) raster else rast(raster)

  if (!hasValues(data)) stop("Raster contains no values.")
  if (!inherits(boundary_polygon, "sf")) stop("Boundary has to be a sf-object.")

  boundary <- st_transform(boundary_polygon, crs(data))
  data_crop <- crop(data, vect(boundary))

  mean <- exact_extract(data_crop, boundary, fun = 'mean') %>% round(3)

  return(mean)
}
