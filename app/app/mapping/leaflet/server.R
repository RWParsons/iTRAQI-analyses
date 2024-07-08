box::use(
  leaflet,
)


#' @export
get_map_proxy <- function(map_id) {
  leaflet$leafletProxy(map_id)
}
