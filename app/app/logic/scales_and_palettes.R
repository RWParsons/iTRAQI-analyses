box::use(
  dplyr,
)

box::use(
  app / data / constants
)


#' @export
seifa_scale_to_text <- function(x) {
  dplyr$case_when(
    x == 1 ~ "Most disadvantaged",
    x == 2 ~ "Disadvantaged",
    x == 3 ~ "Middle socio-economic status",
    x == 4 ~ "Advantaged",
    x == 5 ~ "Most advantaged",
    is.na(x) ~ "NA"
  )
}

#' @export
seifa_text_to_value <- function(x) {
  dplyr$case_when(
    x == "Most disadvantaged" ~ 1,
    x == "Disadvantaged" ~ 2,
    x == "Middle socio-economic status" ~ 3,
    x == "Advantaged" ~ 4,
    x == "Most advantaged" ~ 5,
  )
}

#' @export
seifa_text_choices <- c(seifa_scale_to_text(1:5), "NA")


#' @export
ra_scale_to_text <- function(x) {
  dplyr$case_when(
    x == 0 ~ "Major Cities of Australia",
    x == 1 ~ "Inner Regional Australia",
    x == 2 ~ "Outer Regional Australia",
    x == 3 ~ "Remote Australia",
    x == 4 ~ "Very Remote Australia",
    TRUE ~ "NA"
  )
}

#' @export
ra_text_to_value <- function(x) {
  dplyr$case_when(
    x == "Major Cities of Australia" ~ 0,
    x == "Inner Regional Australia" ~ 1,
    x == "Outer Regional Australia" ~ 2,
    x == "Remote Australia" ~ 3,
    x == "Very Remote Australia" ~ 4,
  )
}

#' @export
ra_text_choices <- ra_scale_to_text(0:4)


palette_list <- readRDS(file.path(constants$analyses_output_dir, "palette_list.rds"))

#' @export
iTRAQI_levels <- palette_list$bins_index


