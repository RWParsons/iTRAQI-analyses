box::use(
  mapgl,
)

#' @export
mapOutput <- function(id) {
  mapgl$mapboxglOutput(id, height = "100%")
}
