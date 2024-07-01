box::use(
  dplyr,
  stringr,
)

box::use(
  app / logic / constants,
)

#' @export
get_standard_layer_name <- function(x) {
  layers_allowed <- c(constants$layer_choices, "sa1_aria")

  is_layer_name <- x %in% names(constants$layer_choices)
  newx <- ifelse(
    is_layer_name,
    constants$layer_choices[names(constants$layer_choices) == x],
    x
  )

  stopifnot(newx %in% layers_allowed)
  newx
}

#' @export
get_layer_type <- function(x) {
  x <- get_standard_layer_name(x)

  dplyr$case_when(
    x == "none" ~ "none",
    stringr$str_detect(x, "^sa[1,2]_") ~ "polygon",
    stringr$str_detect(x, "_time$") ~ "raster"
  )
}


#' @export
clean_marker_group_name <- function(x) {
  clean_x <- dplyr$case_when(
    x == "Towns" ~ "towns",
    x == "Acute centres" ~ "acute_centres",
    x == "Rehab centres" ~ "rehab_centres",
    x == "Aeromedical locations" ~ "rsq",
    x == "QAS response locations" ~ "qas",
    .default = x
  )

  dplyr$if_else(clean_x %in% clean_marker_names, clean_x, NA_character_)
}

clean_marker_names <- c("towns", "acute_centres", "rehab_centres", "rsq", "qas")
