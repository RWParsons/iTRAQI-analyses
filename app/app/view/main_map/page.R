# main_map page
box::use(
  shiny,
  bslib,
  leaflet,
  strayr,
  sf,
  leafgl,
  dplyr,
  shinyWidgets,
)

box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping,
  app / data / shapes,
  app / view / main_map / make_top_cards,
  app / logic / wrangle_data,
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    shiny$tagList(
      bslib$card(
        height = "calc(100vh - 100px)",
        mm$mapOutput(ns("map")),
        make_top_cards$make_controls_ui(ns = ns)
      )
    )
  )
}


#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$map <- mm$make_base_map()
    proxymap <- shiny$reactive(leaflet$leafletProxy("map"))

    map_content <- list(
      list(
        type = "polygon",
        polygon = shapes$stacked_sa1_sa2_polygon_geom
      )
    )

    d_poly <- shiny$reactive({
      wrangle_data$get_poly_selection(
        layer_selection = input$layer_selection,
        seifa = input$seifa,
        remoteness = input$remoteness,
        itraqi_index = input$itraqi_index
      )
    })


    shiny$observe({
      mm$update_map_content(proxymap(), d_poly())
    })
  })

  make_top_cards$make_controls_server(id)
}