% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/noaa_geoms.R
\name{geom_timeline_label}
\alias{geom_timeline_label}
\title{Building geom_timeline_label}
\usage{
geom_timeline_label(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  show.legend = NA,
  na.rm = FALSE,
  inherit.aes = TRUE,
  ...
)
}
\arguments{
\item{mapping}{Internal parameter needed for the geom}

\item{data}{Internal parameter needed for the geom}

\item{stat}{Internal parameter needed for the geom}

\item{position}{Internal parameter needed for the geom}

\item{show.legend}{Internal parameter needed for the geom}

\item{na.rm}{Internal parameter needed for the geom}

\item{inherit.aes}{Internal parameter needed for the geom}

\item{...}{Internal parameter needed for the geom}
}
\description{
Building geom_timeline_label
}
\examples{
\dontrun{
noaa_read("NOAA Significant Earthquake Database.txt") \%>\%
eq_clean_data() \%>\%
filter(str_trim(COUNTRY) \%in\% c("USA") & DATE \%in\% c(ymd("2000-01-01"):ymd("2017-01-01"))) \%>\%
ggplot() +
geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6) +
geom_timeline_label(aes(label = LOCATION_NAME, x = DATE, size=EQ_PRIMARY, n_max = 4)) +
labs(size = "Richter scale value", color = "# DEATHS") +
theme_classic() +
theme(legend.position="bottom")
}

}
