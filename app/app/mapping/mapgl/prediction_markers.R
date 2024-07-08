box::use(
  dplyr,
  glue,
  leaflet,
  sf,
  shinyjs,
  shiny,
  terra,
)


box::use(
  app / logic / load_shapes,
  app / logic / scales_and_palettes,
)



#' @export
add_prediction_marker <- function(proxy_map, map_click) {
  lat <- map_click$lat
  lng <- map_click$lng

  if (!is_point_in_qld(lat = lat, lng = lng)) {
    return()
  }
  # add marker and popup
  acute_pred <- get_pred_time(lng = lng, lat = lat, care_type = "acute")$pred
  rehab_pred <- get_pred_time(lng = lng, lat = lat, care_type = "rehab")$pred

  digits <- 2

  popup <- glue$glue(
    .sep = "<br/>",
    "<b>New location</b>",
    "Longitude: {round(lng, digits)}",
    "Latitude: {round(lat, digits)}",
    "iTRAQI index: {scales_and_palettes$get_itraqi_index(acute_mins=acute_pred, rehab_mins=rehab_pred)}",
    "Acute time prediction: {round(acute_pred, 0)} minutes",
    "Rehab time prediction: {round(rehab_pred, 0)} minutes"
  )

  # proxy_map |>
  #   leaflet$addMarkers(
  #     lng = lng,
  #     lat = lat,
  #     popup = popup,
  #     layerId = "map_click_marker"
  #   )

  shinyjs$runjs(
    sprintf("setTimeout(() => open_popup('%s'), 500)", "map_click_marker")
  )
}


#' @export
handle_marker_click <- function(proxy_map, marker_click) {
  # if (is.null(marker_click$id)) {
  #   return()
  # }
  # if (marker_click$id == "map_click_marker") {
  #   proxy_map |>
  #     leaflet$removeMarker(layerId = "map_click_marker")
  # }
}

is_point_in_qld <- function(lat, lng) {
  point <- sf$st_point(c(lng, lat))
  intersects <- sf$st_intersects(point, load_shapes$state_boundary)
  nrow(as.data.frame(intersects)) > 0
}

get_pred_time <- function(lng, lat, care_type = c("acute", "rehab")) {
  care_type <- paste0(match.arg(care_type), "_raster")

  load_shapes$raster_layers[[care_type]] |>
    terra$as.data.frame(xy = TRUE) |>
    dplyr$as_tibble() |>
    dplyr$mutate(
      y_dist = abs(lat - y),
      x_dist = abs(lng - x),
      euc_dist = sqrt(y_dist^2 + x_dist^2)
    ) |>
    dplyr$slice_min(order_by = euc_dist, n = 1) |>
    dplyr$select(x, y, pred)
}

#' @export
prediction_marker_tags <- function() {
  # https://stackoverflow.com/questions/66240941/r-leaflet-add-a-new-marker-on-the-map-with-the-popup-already-opened
  # shiny$tags$head(
  #   shiny$tags$script(
  #     type = "text/javascript",
  #     shiny$HTML(
  #       paste(
  #         "var mapsPlaceholder = [];",
  #         "L.Map.addInitHook(function () {",
  #         "   mapsPlaceholder.push(this);",
  #         "});",
  #         sep = "\n"
  #       )
  #     ),
  #     shiny$HTML(
  #       paste("function open_popup(id) {",
  #         "   console.log('open popup for ' + id);",
  #         "   mapsPlaceholder[0].eachLayer(function(l) {",
  #         "      if (l.options && l.options.layerId == id) {",
  #         "         l.openPopup();",
  #         "      }",
  #         "   });",
  #         "}",
  #         sep = "\n"
  #       )
  #     )
  #   ),
  #   shinyjs$useShinyjs()
  # )
}
