
test_that("check noaa_read", {
    expect_that(ncol(noaa_read(system.file("extdata",
                                           "NOAA_Significant_Earthquake_Database.txt",
                                           package = "NOAAPackage"))),equals(47))
})

test_that("check eq_location_clean", {
    expect_that(eq_location_clean(data=data.frame(LOCATION_NAME = c("Switzerland:Berne"))),is_equivalent_to("Berne"))
})


test_that("check eq_clean_data", {
    expect_that(ncol(noaa_read(system.file("extdata",
                                           "NOAA_Significant_Earthquake_Database.txt",
                                           package = "NOAAPackage")) %>%
                         eq_clean_data()),equals(45))
})

test_that("check class of the plot1", {
    usa_data <- noaa_read(system.file("extdata",
                                      "NOAA_Significant_Earthquake_Database.txt",
                                      package = "NOAAPackage")) %>%
        eq_clean_data() %>%
        dplyr::filter(stringr::str_trim(COUNTRY) %in% c("USA") & DATE %in% c(ymd("2000-01-01"):ymd("2017-01-01")))

    test1 <- ggplot2::ggplot(data = usa_data) +
        geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6)

    expect_that(test1,is_a("ggplot"))
})


test_that("check class of the plot2", {
    usa_data <- noaa_read(system.file("extdata",
                                      "NOAA_Significant_Earthquake_Database.txt",
                                      package = "NOAAPackage")) %>%
        eq_clean_data() %>%
        filter(str_trim(COUNTRY) %in% c("USA") & DATE %in% c(ymd("2000-01-01"):ymd("2017-01-01")))

    test2 <- ggplot2::ggplot(data = usa_data) +
        geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6) +
        geom_timeline_label(aes(label = LOCATION_NAME, x = DATE, size=EQ_PRIMARY, n_max = 4)) +
        ggplot2::guides(size = ggplot2::guide_legend(title = "Richter scale value")) +
        ggplot2::scale_colour_continuous(name = "# DEATHS") +
        ggplot2::theme_classic() +
        ggplot2::theme(legend.position="bottom")

    expect_that(test2,is_a("ggplot"))
})

test_that("check class of eq_map", {
    test3 <- noaa_read(system.file("extdata",
                                   "NOAA_Significant_Earthquake_Database.txt",
                                   package = "NOAAPackage")) %>%
        eq_clean_data() %>%
        dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
        eq_map(annot_col = "DATE")

    expect_that(test3,is_a("leaflet"))
})


test_that("check eq_create_label", {
    expect_match(eq_create_label(noaa_read(system.file("extdata",
                                                      "NOAA_Significant_Earthquake_Database.txt",
                                                      package = "NOAAPackage")) %>%
                                    eq_clean_data() %>%
                                    dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) == 2010))[1],
                " <b>Location:</b> Baja California <br /> <b>Magnitude:</b> 7.2 <br /> <b>Total deaths:</b> 2 <br />")
})

