#' functions to combine raster results
#' into new raster

#' @param wsf_raster raster with world settlement footprint data
#' @param boundary_polygon vector file with optional boundary units
#' @return total built-up area as sf-object
#' @export


combine <- function(name, raster, wsf) {
  if (!(length(name) == length(raster) && length(raster) == length(wsf))) {
    stop("All input vectors have to be the same length.")
  }

  results <- data.frame(
    name = name,
    raster = raster,
    wsf = wsf
  )

  write.csv(results, file = "combined_results", row.names = FALSE)
  return(results)
}

visualise_correlation <- function(results, y_axis = NULL) {
  library(ggplot2) # for visualising
  library(ggrepel) # for no overlapping labels

  correlation <- cor(results$raster, results$wsf, use = "complete.obs", method = "pearson")

  p1 <- ggplot(results, aes(x = wsf, y = raster)) +
    geom_point(size = 3, color = "red") +  # adding data points
    geom_smooth(method = "lm", color = "blue", linetype = "dashed", aes(group = 1)) +  # regression line
    geom_text_repel(aes(label = "name"), vjust = -0.5, hjust = 0.5, size = 4) +  # city labels
    labs(x = "imperviousness (WSF, %)", y = y_axis,
         title = paste0("Correlation between", y_axis, " and imperviousness"),
         subtitle = paste0("Pearson Correlation: r =", round(correlation, 3))) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.text = element_text(size = 10),
      axis.title = element_text(size = 12, face = "bold"),
      panel.grid = element_line(color = "gray80")
    )

  print(p1)
}




