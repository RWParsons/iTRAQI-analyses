box::use(
  leaflet,
  withr,
)

box::use(
  app / logic / constants
)

palette_list <- readRDS(file.path(constants$data_dir, "palette_list.rds"))

scale_fxs <- readRDS(file.path(constants$data_dir, "scale_fxs.rds"))

#' @export
itraqi_acute_breaks <- palette_list$iTRAQI_acute_breaks

#' @export
itraqi_rehab_breaks <- palette_list$iTRAQI_rehab_breaks

#' @export
get_itraqi_index <- scale_fxs$itraqi_index

#' @export
seifa_scale_to_text <- function(x) {
  withr$with_package("dplyr", scale_fxs$seifa_scale_to_text(x))
}

#' @export
seifa_text_to_value <- function(x) {
  withr$with_package("dplyr", scale_fxs$seifa_text_to_value(x))
}

#' @export
seifa_text_choices <- c(seifa_scale_to_text(1:5), "NA")

#' @export
ra_scale_to_text <- function(x) {
  withr$with_package("dplyr", scale_fxs$ra_scale_to_text(x))
}

#' @export
ra_text_to_value <- function(x) {
  withr$with_package("dplyr", scale_fxs$ra_text_to_value(x))
}

#' @export
ra_text_choices <- ra_scale_to_text(0:4)

#' @export
pal_mins <- function(x) {
  withr$with_package("dplyr", palette_list$palNum(x))
}

#' @export
bins_mins <- palette_list$bins_mins

#' @export
pal_hours <- function(x) {
  withr$with_package("dplyr", palette_list$palNum_hours(x))
}

#' @export
pal_index <- palette_list$paliTRAQI

#' @export
iTRAQI_levels <- levels(palette_list$bins_index)

#' @export
pal_aria <- leaflet$colorFactor(
  "Greens",
  levels = ra_text_choices,
  ordered = TRUE,
  reverse = TRUE
)

#' @export
get_palette <- function(outcome) {
  if (outcome == "index") {
    pal_index
  } else if (outcome == "aria") {
    pal_aria
  } else {
    pal_mins
  }
}
