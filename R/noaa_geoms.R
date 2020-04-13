
#' Creating a new class "GeomTimeline"
#'
#' This geom object uses ggplot2's standard point geom, i.e. GeomPoint and will be used to build the geom_timeline geom.
#'
#' @importFrom ggplot2 ggproto GeomPoint aes draw_key_point
#' @importFrom grid gList linesGrob gpar pointsGrob unit gTree

GeomTimeline <- ggplot2::ggproto("GeomTimeline", ggplot2::GeomPoint,
                                 required_aes = "x",
                                 default_aes = ggplot2::aes(y = 0.5, alpha = 0.2, size=3, colour = "grey55"),
                                 draw_key = ggplot2::draw_key_point,
                                 draw_panel = function(data, panel_scales, coord) {
                                     ## Transform the data first
                                     coords <- coord$transform(data, panel_scales)

                                     ## Construct a grid grob for the baseline
                                     baseline <- c()
                                     for (i in unique(coords$y)) {
                                         baseline <- grid::gList(baseline,
                                                                 grid::linesGrob(
                                                                     x = grid::unit(c(0.01, 0.99), "npc"),
                                                                     y = i,
                                                                     gp = grid::gpar(col = "grey55",
                                                                                     alpha = 0.3,
                                                                                     lwd = 2)
                                                                 )

                                         )
                                     }

                                     points <- grid::pointsGrob(
                                         x = coords$x,
                                         y = coords$y,
                                         pch = 19,
                                         size = grid::unit(coords$size, "char"),
                                         gp = grid::gpar(col = coords$colour,
                                                         fill = coords$colour,
                                                         alpha = coords$alpha,
                                                         fontsize = coords$size
                                         )
                                     )

                                     grid::gTree(children = grid::gList(baseline, points))
                                 }
)

#' Building geom_timeline
#'
#' @examples
#' \dontrun{
#' ggplot(data = usa_data) +
#' geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6)
#' }
#'
#' @export
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", show.legend = NA,
                          na.rm = FALSE, inherit.aes = TRUE,
                          size = size, ...) {
    ggplot2::layer(
        data = data,
        mapping = mapping,
        stat = stat,
        geom = GeomTimeline,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
    )
}


#' Creating a new class "GeomTimelineLabel"
#'
#' This geom object uses ggplot2's standard geom, i.e. Geom and grid's segmentsGrob and textGrob to build the geom_timeline_label geom.
#'
#' @importFrom ggplot2 ggproto Geom aes draw_key_vline
#' @importFrom grid segmentsGrob gpar textGrob gTree gList
#' @importFrom dplyr tbl_df arrange group_by mutate row_number filter ungroup
#' @importFrom magrittr %>%
#'
GeomTimelineLabel <- ggplot2::ggproto("GeomTimelineLabel", ggplot2::Geom, #ggplot2::GeomLabel,
                                      required_aes = c("x","label","size"),
                                      default_aes = ggplot2::aes(y = 0.5, n_max = 5, colour = "grey20", alpha = 0.3),
                                      draw_key = ggplot2::draw_key_vline,

                                      draw_panel = function(data, panel_scales, coord) {
                                          ## Transform the data first
                                          coords <- coord$transform(data, panel_scales)

                                          coords <- coords %>%
                                              dplyr::tbl_df() %>%
                                              dplyr::arrange(desc(size),desc(x)) %>%
                                              dplyr::group_by(y) %>% # dplyr::group_by(group) %>%
                                              dplyr::mutate(rank = dplyr::row_number()) %>%
                                              dplyr::filter(rank<=n_max) %>%
                                              dplyr:: ungroup()

                                          ## Construct a grid grob for segments
                                          segments <- grid::segmentsGrob(
                                              x0 = coords$x,
                                              x1 = coords$x,
                                              y0 = coords$y,
                                              y1 = coords$y+0.1,
                                              gp = grid::gpar(col = coords$colour,
                                                              alpha = coords$alpha)
                                          )

                                          ## Construct a grid grob for text
                                          text <- grid::textGrob(
                                              label = coords$label,
                                              x = coords$x,
                                              y = coords$y+0.11,
                                              rot = 45,
                                              just = "left",
                                              hjust = NULL,
                                              gp = grid::gpar(col="black", fontsize=12)
                                          )

                                          grid::gTree(children = grid::gList(segments, text))
                                      }
)

#' Building geom_timeline_label
#'
#' @examples
#' \dontrun{
#' ggplot(data = usa_data) +
#' geom_timeline(aes(x = DATE, color = DEATHS, size=EQ_PRIMARY), alpha=0.6) +
#' geom_timeline_label(aes(label = LOCATION_NAME, x = DATE, size=EQ_PRIMARY, n_max = 4)) +
#' labs(size = "Richter scale value", color = "# DEATHS") +
#' theme_classic() +
#' theme(legend.position="bottom")
#' }
#'
#' @export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity",
                                position = "identity", show.legend = NA,
                                na.rm = FALSE, inherit.aes = TRUE, ...) {
    ggplot2::layer(
        data = data,
        mapping = mapping,
        stat = stat,
        geom = GeomTimelineLabel,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
    )
}
