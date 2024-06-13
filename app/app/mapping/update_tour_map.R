box::use(
  dplyr,
  leaflet,
  leafgl,
  sf,
  stringr,
  withr,
)


box::use(
  app / logic / constants,
  app / logic / load_shapes,
  app / logic / scales_and_palettes,
  app / logic / wrangle_data,
  app / mapping / update_map_content,
)


#' @export
show_tour <- function(proxy_map, tab, map_content, r_layers) {
  # TODO: trigger changes to map (via calls to update_map_content module mostly)
  # browser()

  print(tab)
  print(map_content)
  # update markers
  update_map_content$update_map_markers(proxy_map = proxy_map, markers = map_content)

  selected_layer <- get_shapes_from_map_content(map_content)

  d_poly <- wrangle_data$get_poly_selection(
    layer_selection = selected_layer,
    seifa = scales_and_palettes$seifa_text_choices,
    remoteness = scales_and_palettes$ra_text_choices,
    itraqi_index = scales_and_palettes$iTRAQI_levels
  )

  update_map_content$update_map_shapes(
    proxy_map = proxy_map,
    d_selection = d_poly,
    selected_layer = selected_layer,
    r_layers = r_layers
  )
}


get_shapes_from_map_content <- function(map_content) {
  dplyr$case_when(
    "sa1_index" %in% map_content ~ "sa1_index",
    "sa1_aria" %in% map_content ~ "sa1_aria",
    .default = "none"
  )
}
