
#' Building eq_map
#'
#' This function creates a map of the earthquakes in a data set and allows for annotation of the data for instance for each point representing
#' an earthquake.
#'
#' @param dataframe A data frame containing relevant information about earthquakes
#' @param annot_col Annotation data stored in the data frame
#'
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' noaa_read("NOAA Significant Earthquake Database.txt") %>%
#' eq_clean_data() %>%
#' dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#' eq_map(annot_col = "DATE")
#' }
#'
#' @export
eq_map <- function(dataframe, annot_col) {
    leaflet::leaflet() %>%
        leaflet::addTiles() %>%
        leaflet::addCircleMarkers(data = dataframe,
                                 radius = 10,
                                 lng = ~ LONGITUDE,
                                 lat = ~ LATITUDE,
                                 popup = ~ paste(eval(parse(text = annot_col))),
                                 weight = 1
        )
}


#' Building eq_create_label
#'
#' This function creates the annotation text for an HTML label of the leaflet map.
#'
#' @param dataframe A data frame containing relevant information about earthquakes
#'
#' @examples
#' \dontrun{
#' noaa_read("NOAA Significant Earthquake Database.txt") %>%
#' eq_clean_data() %>%
#' dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#' dplyr::mutate(popup_text = eq_create_label(.)) %>%
#' eq_map(annot_col = "popup_text")
#' }
#'
#' @export
eq_create_label <- function(dataframe) {
    popup_info <- vector(length = nrow(dataframe))
    for (i in 1:nrow(dataframe)) {
        popup_info[i] <- ""
        if (!is.na(dataframe$LOCATION_NAME[i])) {
            popup_info[i] <- paste(popup_info[i],"<b>Location:</b>", dataframe$LOCATION_NAME[i], "<br />")
        }
        if (!is.na(dataframe$EQ_PRIMARY[i])) {
            popup_info[i] <- paste(popup_info[i],"<b>Magnitude:</b>", dataframe$EQ_PRIMARY[i], "<br />")
        }
        if (!is.na(dataframe$DEATHS[i])) {
            popup_info[i] <- paste(popup_info[i],"<b>Total deaths:</b>", dataframe$DEATHS[i], "<br />")
        }
    }
    popup_info
}
