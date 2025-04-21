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
