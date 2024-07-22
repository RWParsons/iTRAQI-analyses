box::use(
  mapgl,
)


#' @export
get_map_proxy <- function(map_id) {
  mapgl$mapboxgl_proxy(map_id)
}
