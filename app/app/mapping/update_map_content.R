box::use(
  leaflet,
  leafgl,
  dplyr,
)


box::use(
  app / logic / load_shapes,
  app / logic / scales_and_palettes,
)


#' @export
update_map_content <- function(proxy_map, d_selection) {
  proxy_map |>
    leaflet$clearGroup("layers")

  if (is.null(d_selection)) {
    return()
  }

  d_codes_selected <- d_selection$data |>
    dplyr$filter(selected) |>
    dplyr$select(CODE, selected_col, selected_popup)

  poly_add <- load_shapes$stacked_sa1_sa2_polygon_geom |>
    dplyr$inner_join(d_codes_selected, by = "CODE")

  linestring_add <- load_shapes$stacked_sa1_sa2_linestring_geom |>
    dplyr$inner_join(d_codes_selected, by = "CODE")


  if (d_selection$outcome == "index") {
    fcolor_palette <- scales_and_palettes$pal_index
  } else {
    fcolor_palette <- scales_and_palettes$pal_mins
  }

  proxy_map <- proxy_map |>
    leafgl$addGlPolygons(
      data = poly_add,
      pane = "layers",
      group = "layers",
      fillColor = fcolor_palette(poly_add$selected_col)
    ) |>
    leafgl$addGlPolylines(
      data = linestring_add,
      group = "layers",
      color = "black",
      weight = 0.1,
      opacity = 0.5
    )
}
