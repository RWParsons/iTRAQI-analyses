box::use(
  leaflegend,
  leaflet,
  shiny,
  stringr,
)

box::use(
  app / logic / scales_and_palettes,
)


#' @export
update_legend <- function(proxy_map, selected_layer, layer_type) {
  proxy_map |> leaflet$clearControls()

  if (stringr$str_detect(selected_layer, "index")) {
    proxy_map |> add_itraqi_legend()
  } else if (layer_type != "none") {
    proxy_map |> add_continuous_legend()
  }
}

add_itraqi_legend <- \(map) {
  leaflegend$addLegendFactor(
    map = map,
    opacity = 1,
    position = "topright",
    pal = scales_and_palettes$pal_index,
    values = scales_and_palettes$iTRAQI_levels,
    title = "iTRAQI index"
  )
}

add_continuous_legend <- \(map) {
  leaflegend$addLegendNumeric(
    map = map,
    position = "topright",
    pal = scales_and_palettes$pal_hours,
    values = scales_and_palettes$bins_mins / 60,
    title = "Time to care (hours)"
  )
}
