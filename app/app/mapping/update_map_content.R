box::use(
  leaflet,
  leafgl,
  dplyr,
)


box::use(
  app / data / shapes
)


#' @export
update_map_content <- function(proxy_map, d_selection) {
  proxy_map |>
    leaflet$clearGroup("layers")

  if(is.null(d_selection)) return()

  d_codes_selected <- d_selection$data |>
    dplyr$filter(selected) |>
    dplyr$select(CODE)

  poly_add <- shapes$stacked_sa1_sa2_polygon_geom |>
    dplyr$inner_join(d_codes_selected, by = "CODE")

  linestring_add <- shapes$stacked_sa1_sa2_linestring_geom |>
    dplyr$inner_join(d_codes_selected, by = "CODE")

  proxy_map <- proxy_map |>
    leafgl$addGlPolygons(data = poly_add, pane = "layers", group = "layers", fillColor = "red") |>
    leafgl$addGlPolylines(data = linestring_add, group = "layers")
}
