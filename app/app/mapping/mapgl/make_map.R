box::use(
  leaflet,
)

box::use(
  app / logic / load_shapes,
  app / logic / constants,
  app / logic / utils,
)

#' @export
make_base_map <- function(show_default_markers = TRUE, ...) {

}


#' @export
add_map_content <- function(proxy_map, map_content, ...) {

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
