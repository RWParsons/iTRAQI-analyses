# main_map page
box::use(
  shiny,
  bslib,
  leaflet,
  sf,
  leafgl,
  dplyr,
  shinyWidgets,
)

box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping,
  app / view / main_map / make_top_cards,
  app / logic / load_shapes,
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
    layers_rv <- shiny$reactiveValues(current_grp = "A", rasters = c())

    map_content <- list(
      list(
        type = "polygon",
        polygon = load_shapes$stacked_sa1_sa2_polygon_geom
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


    shiny$observeEvent(list(proxymap(), d_poly(), input$layer_selection), {
      mm$update_map_shapes(
        proxy_map = proxymap(),
        d_selection = d_poly(),
        selected_layer = input$layer_selection,
        r_layers = shiny$isolate(layers_rv)
      )
    })


    shiny$observe({
      # TODO: reactively update the proxy_map() markers
      # - probably worth making some function to clean the name as I have
      mm$update_map_markers(
        proxy_map = proxymap(),
        markers = input$base_layers
      )
    })
  })

  make_top_cards$make_controls_server(id)
}
