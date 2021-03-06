% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/noaa_functions.R
\name{eq_location_clean}
\alias{eq_location_clean}
\title{Clean column LOCATION_NAME of the NOAA Significant Earthquake Database data}
\usage{
eq_location_clean(dataset)
}
\arguments{
\item{dataset}{Data set from the NOAA Significante Earthquakte Database}
}
\value{
This function returns a cleaned LOCATION_NAME column of the data set of the NOAA Significante Earthquakte Database
}
\description{
This function takes the NOAA Significant Earthquake Database data as input and cleans the LOCATION_NAME by eliminating the country name
and the colon.
}
\examples{
\dontrun{
noaa_read("NOAA Significant Earthquake Database.txt") \%>\%
eq_location_clean()
}
}
