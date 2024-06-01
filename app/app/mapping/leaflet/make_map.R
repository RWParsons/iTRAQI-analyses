box::use(
  leaflet,
  leafgl,
  sf,
)

#' @export
make_base_map <- function(l_map_content = list()) {
  m <- leaflet$leaflet() |>
    leaflet$addTiles()

  for(sh_idx in 1:length(l_map_content)) {
    sh <- l_map_content[[sh_idx]]

    if(sh$type == "polygon") {
      m <- m |>
        leafgl$addGlPolygons(data = sh$data)
    }

  }

  leaflet$renderLeaflet(m)
}
