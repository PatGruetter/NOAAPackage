
<!-- README.md is generated from README.Rmd. Please edit that file -->

# NOAAPackage

<!-- badges: start -->

<!-- badges: end -->

The goal of NOAAPackage is to display information on destructive
earthquakes from 2150 B.C. to the present provided by the National
Centers For Environmental Information on <https://www.ngdc.noaa.gov>.

## Installation

You can install the released version of NOAAPackage from
[CRAN](https://CRAN.R-project.org) with:

``` r
# install.packages("devtools")
devtools::install_github("PatGruetter/NOAAPackage")
```

## Usage

The package contains a function to read the data and another one to
clean to clean it. Moreover, two geoms are available to visualize and
label earthquakes on a time line, respectively, as well as two functions
to display and label eathquakes on a map, respectively.

First, let’s load the necessary packages:

``` r
library(NOAAPackage)
library(tidyverse)
```

Data can be read into R using the function *noaa\_read()*:

``` r
noaa_data <- noaa_read(system.file("extdata",
                                   "NOAA_Significant_Earthquake_Database.txt",
                                   package = "NOAAPackage"))
```

The data set needs to be cleaned using the function *eq\_clean\_data()*
so that the data can later be used with the provided geoms and functions
for visualizations and map plots.

``` r
noaa_data_cleaned <- noaa_data %>% 
  eq_clean_data()
```

Let’s have a look at the geom called *geom\_timeline()* and at the plot
it makes:

``` r
usa_data <- noaa_data_cleaned %>%
  filter(str_trim(COUNTRY) %in% c("USA") & DATE %in% c(ymd("2000-01-01"):ymd("2017-01-01")))

ggplot(data = usa_data) +
    geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

If you want to add lables to the n\_max largest earthquakes, you can add
another geom called *geom\_timeline\_label()* after *geom\_timeline()*:

``` r
ggplot(data = usa_data) +
    geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6) + 
    geom_timeline_label(aes(label = LOCATION_NAME, x = DATE, size=EQ_PRIMARY, n_max = 4)) +
    guides(size = guide_legend(title = "Richter scale value")) +
    scale_colour_continuous(name = "# DEATHS") +
    theme_classic() +
    theme(legend.position="bottom")
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

Earthquakes can also be shown on a map using the NOAA package functions
for data cleaning, i.e. *eq\_clean\_data()* as well as the function to
display the earthquake locations on a map, i.e. *eq\_map()*. If you
click on one of the locations, the date of the earthquake pops up. Note
that the map is not shown in this README document.

``` r
noaa_data %>%
    eq_clean_data() %>%
    dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>% 
    eq_map(annot_col = "DATE")
```

To receive more information about the event such as location, magnitude
and total deaths - in case the information is available - you can use
the function *eq\_create\_label()* as shown in the following example.
Note that the map is not shown in this README document.

``` r
noaa_data %>%
    eq_clean_data() %>% 
    dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>% 
    dplyr::mutate(popup_text = eq_create_label(.)) %>% 
    eq_map(annot_col = "popup_text")
```
