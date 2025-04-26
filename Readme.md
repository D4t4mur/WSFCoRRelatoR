# WSF-CoRRelatoR

The package provides functions to quickly calculate and display the correlation between any given raster dataset with a single variable and the world settlement footprint.


## Conditions

need to have a raster with existing coordinate reference system.
need to download the matching world settlement footprint tile on "https://download.geoservice.dlr.de/WSF2019/"





## Dependencies

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


´´´
## Functions

```r
load_example_data()
rastmeancalc()
wsfmeancalc()
builtuparea()

combine()
visual_correlation()
