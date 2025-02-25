box::use(
  dplyr,
  stringr,
)

box::use(
  app / logic / load_shapes,
  app / logic / scales_and_palettes,
  app / logic / utils,
)

#' @export
get_poly_selection <- function(layer_selection,
                               seifa,
                               remoteness,
                               itraqi_index) {
  layer <- utils$get_standard_layer_name(layer_selection)

  if (!stringr$str_detect(layer, "sa[1,2]")) {
    return()
  }

  sa_level <- as.numeric(stringr$str_extract(layer, "(?<=sa)[1,2]"))
  care_str <- stringr$str_extract(layer, "(?<=sa[1,2]_).*")

  care_type_outcome <- dplyr$case_when(
    care_str == "index" ~ "value_index",
    care_str == "acute" ~ "value_acute",
    care_str == "rehab" ~ "value_rehab",
    care_str == "aria" ~ "ra"
  )

  care_type_popup <- dplyr$case_when(
    care_str == "index" ~ "popup_index",
    care_str == "acute" ~ "popup_acute",
    care_str == "rehab" ~ "popup_rehab"
  )

  d <- load_shapes$stacked_sa1_sa2_data |>
    dplyr$filter(
      SA_level == sa_level
    ) |>
    dplyr$mutate(
      selected = seifa_quintile %in% scales_and_palettes$seifa_text_to_value(seifa) &
        ra %in% scales_and_palettes$ra_text_to_value(remoteness) &
        value_index %in% itraqi_index
    ) |>
    dplyr$rename(selected_col := care_type_outcome)

  if (care_str == "aria") {
    d <- d |>
      dplyr$mutate(selected_col = scales_and_palettes$ra_scale_to_text(selected_col))
  }

  if (care_type_popup %in% names(d)) {
    d <- d |> dplyr$rename(selected_popup := care_type_popup)
  }

  list(
    data = d,
    outcome = care_str
  )
}
