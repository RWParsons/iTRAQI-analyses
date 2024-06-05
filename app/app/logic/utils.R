box::use(
  dplyr,
  stringr,
)

box::use(
  app / logic / constants,
)

#' @export
get_standard_layer_name <- function(x) {
  is_layer_name <- x %in% names(constants$layer_choices)
  newx <- ifelse(
    is_layer_name,
    constants$layer_choices[names(constants$layer_choices) == x],
    x
  )

  stopifnot(newx %in% constants$layer_choices)
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
