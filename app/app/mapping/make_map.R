box::use(
  leaflet,
  leafgl,
  sf,
)

#' @export
make_base_map <- function(l_map_content = list()) {
  m <- leaflet$leaflet() |>
    leaflet$addTiles() |>
    leaflet$setView(144.4583, -22.49671, zoom = 5) |>
    leaflet$addProviderTiles("CartoDB.VoyagerNoLabels") |>
    leaflet$addProviderTiles(
      "CartoDB.VoyagerOnlyLabels",
      options = leaflet$leafletOptions(pane = "maplabels"),
      group = "map labels"
    ) |>
    leaflet$addMapPane(name = "layers", zIndex = 200)  |>
    leaflet$addMapPane(name = "maplabels", zIndex = 400)
    # leaflet$addMapPane(name = "markers", zIndex = 206)  |>
    # leaflet$addMapPane(name = "acute_centres", zIndex = 205)  |>
    # leaflet$addMapPane(name = "rehab_centres", zIndex = 204) |>
    # leaflet$addMapPane(name = "rsq_centres", zIndex = 205) |>
    # leaflet$addMapPane(name = "qas_centres", zIndex = 210) |>

  leaflet$renderLeaflet(m)
}


#' @export
add_map_content <- function(proxy_map, map_content) {
  for(sh_idx in 1:length(map_content)) {
    sh <- map_content[[sh_idx]]

    if(sh$type == "polygon") {
      proxy_map <- proxy_map |>
        leafgl$addGlPolygons(data = sh$polygon)
    }

    if(sh$type == "linestring") {
      proxy_map <- proxy_map |>
        leafgl$addGlPolylines(data = sh$linestring)
    }
  }
}


