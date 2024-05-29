box::use(
  leaflet,
)



#' @export
make_base_map <- function(l_map_content = list()) {
  m <- leaflet$leaflet() |>
    leaflet$addTiles()

  leaflet$renderLeaflet(m)
}
