box::use(
  leaflet,
  leafgl,
  sf,
)

box::use(
  app / logic / load_shapes,
)

#' @export
make_base_map <- function() {
  m <- leaflet$leaflet() |>
    leaflet$setView(144.4583, -22.49671, zoom = 5) |>
    leaflet$addMapPane(name = "layers", zIndex = 200) |>
    leaflet$addMapPane(name = "maplabels", zIndex = 400) |>
    leaflet$addMapPane(name = "acute_centres", zIndex = 205) |>
    leaflet$addMapPane(name = "rehab_centres", zIndex = 204) |>
    leaflet$addMapPane(name = "rsq_centres", zIndex = 205) |>
    leaflet$addMapPane(name = "qas_centres", zIndex = 210) |>
    leaflet$addProviderTiles("CartoDB.VoyagerNoLabels") |>
    leaflet$addProviderTiles("CartoDB.VoyagerOnlyLabels",
      options = leaflet$leafletOptions(pane = "maplabels"),
      group = "map labels"
    )

  l_markers <- load_shapes$l_markers

  m <- m |>
    leaflet$addCircleMarkers(
      lng = l_markers$d_towns$x, lat = l_markers$d_towns$y,
      radius = 2, fillOpacity = 0,
      popup = l_markers$d_towns$popup,
      group = "towns"
    ) |>
    leaflet$addMarkers(
      lng = l_markers$d_acute_centres$x,
      lat = l_markers$d_acute_centres$y,
      icon = centre_icons["acute"],
      popup = l_markers$d_acute_centres$popup,
      group = "acute_centres",
      options = leaflet$leafletOptions(pane = "acute_centres")
    ) |>
    leaflet$addMarkers(
      lng = l_markers$d_rehab_centres$x,
      lat = l_markers$d_rehab_centres$y,
      icon = centre_icons["rehab"],
      popup = l_markers$d_rehab_centres$popup,
      group = "rehab_centres",
      options = leaflet$leafletOptions(pane = "rehab_centres")
    ) |>
    leaflet$addMarkers(
      lng = l_markers$d_rsq_locations$x,
      lat = l_markers$d_rsq_locations$y,
      popup = l_markers$d_rsq_locations$popup,
      icon = centre_icons["rsq"],
      group = "rsq",
      options = leaflet$leafletOptions(pane = "rsq_centres")
    ) |>
    leaflet$addMarkers(
      lng = l_markers$d_qas_locations$x,
      lat = l_markers$d_qas_locations$y,
      popup = l_markers$d_qas_locations$popup,
      icon = centre_icons["qas"],
      group = "qas",
      options = leaflet$leafletOptions(pane = "qas_centres")
    )


  leaflet$renderLeaflet(m)
}


#' @export
add_map_content <- function(proxy_map, map_content) {
  for (sh_idx in 1:length(map_content)) {
    sh <- map_content[[sh_idx]]
    if (sh$type == "polygon") {
      proxy_map <- proxy_map |>
        leafgl$addGlPolygons(data = sh$polygon, layerId = sh$layerid, pane = "layers", group = "layers")
    }

    if (sh$type == "linestring") {
      proxy_map <- proxy_map |>
        leafgl$addGlPolylines(data = sh$linestring, layerId = sh$layerid, group = "layers")
    }
  }
}


centre_icons <- leaflet$iconList(
  acute = leaflet$makeIcon(iconUrl = "static/images/acute-centre.png", iconWidth = 50, iconHeight = 50),
  rehab = leaflet$makeIcon(iconUrl = "static/images/rehab-centre.png", iconWidth = 40, iconHeight = 40),
  rsq = leaflet$makeIcon(iconUrl = "static/images/rsq.png", iconWidth = 50, iconHeight = 30),
  qas = leaflet$makeIcon(iconUrl = "static/images/qas.png", iconWidth = 10, iconHeight = 10)
)
