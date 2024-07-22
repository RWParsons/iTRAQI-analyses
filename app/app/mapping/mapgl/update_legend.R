box::use(
  # leaflegend,
  # leaflet,
  stringr,
)

box::use(
  app / logic / scales_and_palettes,
)


#' @export
update_legend <- function(proxy_map, selected_layer, layer_type) {
  # proxy_map |> leaflet$clearControls()
#
  # if (stringr$str_detect(selected_layer, "index")) {
  #   proxy_map |> add_itraqi_legend()
  # } else if (stringr$str_detect(selected_layer, "aria")) {
  #   proxy_map |> add_aria_legend()
  # } else if (layer_type != "none") {
  #   proxy_map |> add_continuous_legend()
  # }
}

legend_position <- "topleft"

add_itraqi_legend <- \(map) {
  # leaflegend$addLegendFactor(
  #   map = map,
  #   opacity = 1,
  #   position = legend_position,
  #   pal = scales_and_palettes$pal_index,
  #   values = scales_and_palettes$iTRAQI_levels,
  #   title = "iTRAQI index"
  # )
}

add_aria_legend <- \(map) {
  # leaflegend$addLegendFactor(
  #   map = map,
  #   position = legend_position,
  #   pal = scales_and_palettes$pal_aria,
  #   values = factor(
  #     scales_and_palettes$ra_text_choices,
  #     levels = scales_and_palettes$ra_text_choices
  #   ),
  #   layerId = "ariaLegend"
  # )
}

add_continuous_legend <- \(map) {
  # leaflegend$addLegendNumeric(
  #   map = map,
  #   position = legend_position,
  #   pal = scales_and_palettes$pal_hours,
  #   values = scales_and_palettes$bins_mins / 60,
  #   title = "Time to care (hours)"
  # )
}
