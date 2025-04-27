#' visual_correlation()
#'
#' function to calculate the correlation between world settlement footprint and
#' the examined variable and visualisation in a graph

#' @param results dataframe with three columns, return result of combine-function
#' @param y_axis name of the y-axis that should be displayed
#' @return a gg2-plot graph with the results
#' @export

visual_correlation <- function(results, y_axis = NULL) {

  library(ggplot2) # for visualising
  library(ggrepel) # for no overlapping labels

  correlation <- cor(results$raster, results$wsf, use = "complete.obs", method = "pearson")

  p1 <- ggplot(results, aes(x = wsf, y = raster)) +
    geom_point(size = 3, color = "red") +  # adding data points
    geom_smooth(method = "lm", color = "blue", linetype = "dashed", aes(group = 1)) +  # regression line
    geom_text_repel(aes(label = name), vjust = -0.5, hjust = 0.5, size = 4) +  # city labels
    labs(x = "imperviousness (WSF, %)", y = y_axis,
         title = paste0("Correlation between ", y_axis, " and imperviousness"),
         subtitle = paste0("Pearson Correlation: r =", round(correlation, 3))) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.text = element_text(size = 10),
      axis.title = element_text(size = 12, face = "bold"),
      panel.grid = element_line(color = "gray80")
    )

  return(p1)
}




