box::use(
  leaflet,
)

#' @export
mapOutput <- function(id) {
  leaflet$leafletOutput(id, width = "100%", height = "100%")
}
