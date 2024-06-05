box::use(
  dplyr,
  leaflet,
  leafgl,
  stringr,
  withr,
)


box::use(
  app / logic / load_shapes,
  app / logic / scales_and_palettes,
  app / logic / utils,
  app / mapping / update_legend,
)

#' @export
update_map_content <- function(proxy_map, d_selection, selected_layer, r_layers) {
  layer_type <- utils$get_layer_type(selected_layer)
  selected_layer <- utils$get_standard_layer_name(selected_layer)

  if (layer_type == "none") {
    show_nothing(proxy_map = proxy_map, r_layers = r_layers)
  } else if (layer_type == "polygon") {
    show_polygon(proxy_map = proxy_map, d_selection = d_selection, r_layers = r_layers)
  } else if (layer_type == "raster") {
    show_raster(proxy_map = proxy_map, selected_layer = selected_layer, r_layers = r_layers)
  }

  update_legend$update_legend(
    proxy_map = proxy_map,
    selected_layer = selected_layer,
    layer_type = layer_type
  )
}

show_nothing <- function(proxy_map, r_layers) {
  proxy_map |>
    remove_or_hide_grp(grp = r_layers$current_grp)
}

show_raster <- function(proxy_map, selected_layer, r_layers) {
  grp_remove <- r_layers$current_grp
  grp_add <- selected_layer

  if (selected_layer %in% r_layers$rasters) {
    # layer is already added to map but hidden can show it (rather than add it)
    proxy_map |>
      leaflet$showGroup(grp_add) |>
      remove_or_hide_grp(grp_remove)
  } else {
    # layer is not yet added to map, need to add it and then add to r_layers$rasters to indicate
    # that it can just be shown/hidden for later.
    d_raster <- load_shapes$raster_layers[[stringr$str_replace(selected_layer, "time", "raster")]]
    proxy_map |>
      leaflet$hideGroup(grp_add) |>
      leaflet$addRasterImage(
        x = d_raster,
        group = grp_add,
        colors = scales_and_palettes$pal_mins
      )
    r_layers$rasters <- unique(c(r_layers$rasters, selected_layer))
  }

  proxy_map |>
    leaflet$showGroup(grp_add) |>
    remove_or_hide_grp(grp_remove)

  r_layers$current_grp <- grp_add
}

show_polygon <- function(proxy_map, d_selection, r_layers) {
  grp_remove <- r_layers$current_grp
  grp_add <- swap_polygon_grp(r_layers$current_grp)

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

  proxy_map |>
    leaflet$hideGroup(grp_add) |>
    leafgl$addGlPolygons(
      data = poly_add,
      pane = "layers",
      group = grp_add,
      popup = poly_add$selected_popup,
      fillColor = fcolor_palette(poly_add$selected_col)
    ) |>
    leafgl$addGlPolylines(
      data = linestring_add,
      group = grp_add,
      color = "black",
      weight = 0.1,
      opacity = 0.5
    )

  proxy_map |>
    leaflet$showGroup(grp_add) |>
    remove_or_hide_grp(grp_remove)

  r_layers$current_grp <- grp_add
}

remove_or_hide_grp <- function(proxy_map, grp) {
  if (is_polygon_grp(grp)) {
    proxy_map |>
      leaflet$clearGroup(grp)
  }
  if (is_raster_grp(grp)) {
    proxy_map |>
      leaflet$hideGroup(grp)
  }
}

polygon_grps <- c("A", "B")

swap_polygon_grp <- function(grp) {
  ifelse(grp == polygon_grps[1], polygon_grps[2], polygon_grps[1])
}

is_polygon_grp <- function(grp) {
  grp %in% polygon_grps
}

is_raster_grp <- function(grp) {
  grp %in% c("acute_time", "rehab_time")
}
