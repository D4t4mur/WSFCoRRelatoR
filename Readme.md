# WSF-CoRRelatoR

This package provides functions to quickly calculate and display the correlation between the mean value of any given raster dataset with a single variable and the world settlement footprint.


## Conditions

For using this package in the best way, you need to have a raster (or multiple) with an existing coordinate reference system and a single value per pixel where the mean value can be extracted.
Furthermore the different areas to compare should be available in an vector format (polygon).
For the world settlement footprint you can download the matching tile on "https://download.geoservice.dlr.de/WSF2019/".


## Dependencies

The package uses the following packages:
- `terra`
- `sf`
- `dplyr`
- `ggplot2`
- `ggrepel`


## Installation

You can simply install the package via

```r
library(devtools)
install_github("D4t4mur/WSF-CoRRelatoR")
library(Rpollution)
```


## Functions

The following functions are built in so far in this package:

- 'load_example_data()': loads examplary data, a summer-mean land surface temperature raster for Berlin, the wsf raster tile for Berlin and the twelve districts of Berlin as a shp-file
- 'rastmeancalc()': extracts all raster pixel values and calculates the mean
- 'wsfmeancalc()': extracts all wsf raster pixel values and calculates the built-up area / imperviousness in %
- 'builtuparea()': masks the examined polygon with the built-up area from the wsf raster
- 'combine()': combines the extracted values from data raster, wsf raster in a data frame
- 'visual_correlation()': calculates the correlation and displays a plot showcasing the result


## Example

To load the examplary data, execute:

```r
load_example_data()
