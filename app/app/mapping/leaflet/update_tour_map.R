box::use(
  dplyr,
  leaflet,
  shinyjs,
)


box::use(
  app / logic / scales_and_palettes,
  app / logic / wrangle_data,
  app / mapping / leaflet / update_map_content,
)


#' @export
show_tour <- function(proxy_map, r_tab, map_content, r_layers) {
  # update markers
  update_map_content$update_map_markers(
    proxy_map = proxy_map,
    markers = map_content
  )

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

  pan_map_tour(proxy_map, r_tab)
}

qld_bounds <- list(
  lng1 = 137.725724,
  lat1 = -28.903687,
  lng2 = 151.677076,
  lat2 = -10.772608
)


pan_map_tour <- function(proxy_map, r_tab) {
  if (!r_tab() %in% c(3, 4, 5)) {
    return()
  }

  if (r_tab() == 3) {
    proxy_map |>
      leaflet$flyTo(lng = 142.93, lat = -11.15, zoom = 8)

    shinyjs$delay(6000, {
      if (r_tab() == 3) {
        proxy_map |>
          leaflet$flyToBounds(
            lng1 = qld_bounds$lng1, lat1 = qld_bounds$lat1,
            lng2 = qld_bounds$lng2, lat2 = qld_bounds$lat2
          )
      }
    })
  }

  if (r_tab() == 4) {
    proxy_map |>
      leaflet$flyToBounds(
        lng1 = 152.78,
        lat1 = -27.12,
        lng2 = 153.7,
        lat2 = -28.15
      )
    shinyjs$delay(6000, {
      if (r_tab() == 4) {
        proxy_map |>
          leaflet$flyTo(lng = 146.76, lat = -19.32, zoom = 8)
      }
    })
  }

  if (r_tab() == 5) {
    proxy_map |>
      leaflet$flyToBounds(
        lng1 = qld_bounds$lng1, lat1 = qld_bounds$lat1,
        lng2 = qld_bounds$lng2, lat2 = qld_bounds$lat2
      )
  }
}


get_shapes_from_map_content <- function(map_content) {
  dplyr$case_when(
    "sa1_index" %in% map_content ~ "sa1_index",
    "sa1_aria" %in% map_content ~ "sa1_aria",
    "acute_time" %in% map_content ~ "acute_time",
    "rehab_time" %in% map_content ~ "rehab_time",
    .default = "none"
  )
}
