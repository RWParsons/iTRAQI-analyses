box::use(
  dplyr,
  leaflet,
  leafgl,
  sf,
  stringr,
)


box::use(
  app / logic / constants,
  app / logic / load_shapes,
  app / logic / scales_and_palettes,
  app / logic / utils,
  app / mapping / leaflet / update_legend,
)

plot_interaction_groups <- c("clicked_point", "brushed_points")

#' @export
clear_plot_interactions <- function(proxy_map) {
  proxy_map |>
    leaflet$clearGroup(plot_interaction_groups)
}

#' @export
add_clicked_point <- function(proxy_map, d_clicked) {
  d_clicked_top <- d_clicked |>
    dplyr$filter(!is.na(CODE)) |>
    dplyr$slice(1)

  if (nrow(d_clicked_top) > 0) {
    d_popup_add <- load_shapes$stacked_sa1_sa2_polygon_geom |>
      dplyr$inner_join(
        dplyr$select(d_clicked_top, CODE, selected_popup),
        by = "CODE"
      )

    suppressWarnings({
      d_coords <- d_popup_add |>
        sf$st_centroid() |>
        sf$st_coordinates()
    })

    proxy_map |>
      leaflet$addPopups(
        lng = d_coords[1],
        lat = d_coords[2],
        popup = d_popup_add$selected_popup,
        group = "clicked_point"
      )
  }
}

#' @export
add_brushed_polylines <- function(proxy_map, d_selection) {
  linestring_add <- load_shapes$stacked_sa1_sa2_linestring_geom |>
    dplyr$inner_join(dplyr$select(d_selection, CODE), by = "CODE")

  if (nrow(linestring_add) > 0) {
    proxy_map |>
      leafgl$addGlPolylines(
        data = linestring_add,
        group = "brushed_points",
        color = "darkgreen",
        weight = 0.4,
        opacity = 0.7
      )
  }
}

#' @export
update_map_markers <- function(proxy_map, markers) {
  markers <- utils$clean_marker_group_name(markers)

  all_layers <- utils$clean_marker_group_name(constants$all_base_layers)

  hide_groups <- all_layers[!all_layers %in% markers]
  show_groups <- all_layers[all_layers %in% markers]

  proxy_map |>
    leaflet$hideGroup(hide_groups) |>
    leaflet$showGroup(show_groups)
}

#' @export
update_map_shapes <- function(proxy_map,
                              d_selection,
                              selected_layer,
                              r_layers) {
  layer_type <- utils$get_layer_type(selected_layer)
  selected_layer <- utils$get_standard_layer_name(selected_layer)

  if (layer_type == "none") {
    show_nothing(proxy_map = proxy_map, r_layers = r_layers)
  } else if (layer_type == "polygon") {
    show_polygon(
      proxy_map = proxy_map,
      d_selection = d_selection,
      r_layers = r_layers
    )
  } else if (layer_type == "raster") {
    show_raster(
      proxy_map = proxy_map,
      selected_layer = selected_layer,
      r_layers = r_layers
    )
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
    dplyr$select(dplyr$any_of(c("CODE", "selected_col", "selected_popup")))

  poly_add <- load_shapes$stacked_sa1_sa2_polygon_geom |>
    dplyr$inner_join(d_codes_selected, by = "CODE")

  linestring_add <- load_shapes$stacked_sa1_sa2_linestring_geom |>
    dplyr$inner_join(d_codes_selected, by = "CODE")

  fcolor_palette <- scales_and_palettes$get_palette(d_selection$outcome)

  proxy_map |> leaflet$hideGroup(grp_add)

  if (nrow(poly_add) > 1) {
    proxy_map |>
      leafgl$addGlPolygons(
        data = poly_add,
        pane = "layers",
        group = grp_add,
        popup = poly_add$selected_popup,
        fillOpacity = 1,
        fillColor = fcolor_palette(poly_add$selected_col)
      )
  }

  if (nrow(linestring_add) > 1) {
    proxy_map |>
      leafgl$addGlPolylines(
        data = linestring_add,
        group = grp_add,
        color = "black",
        weight = 0.1,
        opacity = 0.5
      )
  }

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
