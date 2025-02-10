box::use(
  leaflet,
  leafgl,
)

box::use(
  app / logic / load_shapes,
  app / logic / constants,
  app / logic / utils,
)

#' @export
make_base_map <- function(show_default_markers = TRUE) {
  m <- leaflet$leaflet() |>
    leaflet$setView(144.4583, -22.49671, zoom = 5) |>
    leaflet$addMapPane(name = "layers", zIndex = 200) |>
    leaflet$addMapPane(name = "maplabels", zIndex = 1400) |>
    leaflet$addMapPane(name = "acute_centres", zIndex = 1205) |>
    leaflet$addMapPane(name = "rehab_centres", zIndex = 1204) |>
    leaflet$addMapPane(name = "rsq", zIndex = 1205) |>
    leaflet$addMapPane(name = "qas", zIndex = 1210) |>
    leaflet$addProviderTiles("CartoDB.VoyagerNoLabels") |>
    leaflet$addProviderTiles("CartoDB.VoyagerOnlyLabels",
      options = leaflet$leafletOptions(pane = "maplabels"),
      group = "map labels"
    )

  l_markers <- load_shapes$l_markers


  if (show_default_markers) {
    marker_grps_hide <- constants$all_base_layers[!constants$all_base_layers %in% constants$default_base_layers]
  } else {
    marker_grps_hide <- constants$all_base_layers
  }

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
      options = leaflet$leafletOptions(pane = "rsq")
    ) |>
    leaflet$addMarkers(
      lng = l_markers$d_qas_locations$x,
      lat = l_markers$d_qas_locations$y,
      popup = l_markers$d_qas_locations$popup,
      icon = centre_icons["qas"],
      group = "qas",
      options = leaflet$leafletOptions(pane = "qas")
    ) |>
    leaflet$hideGroup(utils$clean_marker_group_name(marker_grps_hide))

  leaflet$renderLeaflet(m)
}


#' @export
add_map_content <- function(proxy_map, map_content) {
  for (sh_idx in seq_along(length(map_content))) {
    sh <- map_content[[sh_idx]]
    if (sh$type == "polygon") {
      proxy_map <- proxy_map |>
        leafgl$addGlPolygons(
          data = sh$polygon,
          layerId = sh$layerid,
          fillOpacity = 1,
          pane = "layers",
          group = "layers"
        )
    }

    if (sh$type == "linestring") {
      proxy_map <- proxy_map |>
        leafgl$addGlPolylines(
          data = sh$linestring,
          layerId = sh$layerid,
          group = "layers"
        )
    }
  }
}


centre_icons <- leaflet$iconList(
  acute = leaflet$makeIcon(
    iconUrl = "static/images/acute-centre.png",
    iconWidth = 50,
    iconHeight = 50
  ),
  rehab = leaflet$makeIcon(
    iconUrl = "static/images/rehab-centre.png",
    iconWidth = 40,
    iconHeight = 40
  ),
  rsq = leaflet$makeIcon(
    iconUrl = "static/images/rsq.png",
    iconWidth = 50,
    iconHeight = 30
  ),
  qas = leaflet$makeIcon(
    iconUrl = "static/images/qas.png",
    iconWidth = 10,
    iconHeight = 10
  )
)
