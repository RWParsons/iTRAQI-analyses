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
  app / mapping / update_map_content,
)


#' @export
show_tour <- function(proxy_map, tab, map_content) {
  # TODO: trigger changes to map (via calls to update_map_content module mostly)
  # browser()
}
