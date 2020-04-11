
#' NOAA Significant Earthquake Database data import
#'
#' This function takes the NOAA Significant Earthquake Database txt.-files and imports the file in case it is available and returns a data frame
#' as a tibble.
#' Messages caused by the import are suppressed. In case the file does not exist, the program stops and prints
#' out that the file does not exist.
#'
#' @param filename A character string containing the path and the file name of a txt.-file.
#'
#' @return This function returns the imported file as a tibble data frame.
#'
#' @note The function stops if the file name provided does not exist.
#'
#' @importFrom dplyr tbl_df
#'
#' @examples
#' \dontrun{
#' noaa_read("NOAA Significant Earthquake Database.txt")
#' }
#'
#' @export
noaa_read <- function(filename) {
    if(!file.exists(filename))
        stop("file '", filename, "' does not exist")
    data <- suppressMessages({
        # readr::read_delim(filename, delim = "\t", progress = FALSE)
        read.delim(filename, stringsAsFactors=FALSE)
    })
    dplyr::tbl_df(data)
}



#' Check if lubridate is installed
#'
#' This function installs and loads the lubridate package in case is has not been downloaded and loaded
#'
#' @return This function installs and loads the lubridate package in case is has not been downloaded and loaded
#'
#' @examples
#' \dontrun{
#' check_lubridate()
#' }
#'
check_lubridate <- function() {
    if(!require(lubridate)) {
        message("installing the 'lubridate' package")
        install.packages("lubridate")
    }
    if(!require(lubridate))
        stop("the 'lubridate' package needs to be installed first")
}

#' Clean column LOCATION_NAME of the NOAA Significant Earthquake Database data
#'
#' This function takes the NOAA Significant Earthquake Database data as input and cleans the LOCATION_NAME by eliminating the country name
#' and the colon.
#'
#' @param dataset Data set from the NOAA Significante Earthquakte Database
#'
#' @return This function returns a cleaned LOCATION_NAME column of the data set of the NOAA Significante Earthquakte Database
#'
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom stringr str_to_title str_trim
#'
#' @examples
#' \dontrun{
#' eq_location_clean(NOAA_dataset)
#' }

eq_location_clean <- function(dataset) {
    dataset %>%
        dplyr::mutate(LOCATION_NAME = gsub("[A-Za-z]+:","",LOCATION_NAME),
                      LOCATION_NAME = stringr::str_to_title(stringr::str_trim(LOCATION_NAME)))
}


#' Clean NOAA Significant Earthquake Database data
#'
#' This function takes the NOAA Significant Earthquake Database data as input and gives back a cleaned data set as a tibble.
#'
#' @param dataset Data set from the NOAA Significante Earthquakte Database
#'
#' @return This function returns a cleaned data set of the NOAA Significante Earthquakte Database containing a date column
#'
#' @importFrom dplyr mutate select
#' @importFrom magrittr %>%
#' @importFrom lubridate %m-% ymd years
#' @importFrom tidyr unite
#' @importFrom stringr str_pad
#'
#' @examples
#' \dontrun{
#' eq_clean_data(NOAA_dataset)
#' }
#'
#' @export
eq_clean_data <- function(dataset) {
    check_lubridate()
    dataset %>%
        dplyr::mutate(BC = ifelse(YEAR<0,1,0),
                      YEAR = abs(YEAR),
                      MONTH = ifelse(is.na(MONTH),1,MONTH),
                      DAY = ifelse(is.na(DAY),1,DAY),
                      year_tmp = YEAR,
                      YEAR = stringr::str_pad(YEAR,4,"left",pad = "0"),
                      MONTH = stringr::str_pad(MONTH,2,"left",pad = "0"),
                      DAY = stringr::str_pad(DAY,2,"left",pad = "0")) %>%
        tidyr::unite(DATE, YEAR, MONTH, DAY, sep = "-") %>%
        dplyr::mutate(DATE = lubridate::ymd(DATE),
                      DATE = DATE %m-% lubridate::years(BC*2*year_tmp)) %>%
        select(-BC,-year_tmp) %>%
        eq_location_clean()
}
