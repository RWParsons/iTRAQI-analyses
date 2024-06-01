box::use(
  stringr,
  dplyr,
)

box::use(
  app / data / shapes,
  app / data/ constants,
  app / logic / scales_and_palettes
)

#' @export
get_poly_selection <- function(layer_selection,
                               seifa,
                               remoteness,
                               itraqi_index) {

  layer <- constants$layer_choices[names(constants$layer_choices) == layer_selection]

  if(!stringr$str_detect(layer, "sa[1,2]")) {
    return()
  }

  sa_level <- as.numeric(stringr$str_extract(layer, "(?<=sa)[1,2]"))
  care_str <- stringr$str_extract(layer, "(?<=sa[1,2]_).*")

  care_type_outcome <- dplyr$case_when(
    care_str == "index" ~ "value_index",
    care_str == "acute" ~ "value_acute",
    care_str == "rehab" ~ "value_rehab"
  )

  care_type_popup <- dplyr$case_when(
    care_str == "index" ~ "popup_index",
    care_str == "acute" ~ "popup_acute",
    care_str == "rehab" ~ "popup_rehab"
  )

  d <- shapes$stacked_sa1_sa2_data |>
    dplyr$filter(
      SA_level == sa_level
    ) |>
    dplyr$mutate(
      selected = seifa_quintile %in% scales_and_palettes$seifa_text_to_value(seifa) &
      ra %in% scales_and_palettes$ra_text_to_value(remoteness) &
      value_index %in% itraqi_index
    ) |>
    dplyr$rename(
      selected_col := care_type_outcome,
      selected_popup := care_type_popup
    )

  list(
    data = d,
    outcome = care_str
  )

}
