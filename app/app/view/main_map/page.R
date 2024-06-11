# main_map page
box::use(
  bslib,
  dplyr,
  ggplot2,
  leafgl,
  leaflet,
  shiny,
  shinyWidgets,
  sf,
)


box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping,
  app / view / main_map / interactive_plot,
  app / view / main_map / make_top_cards,
  app / logic / load_shapes,
  app / logic / wrangle_data,
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    mm$prediction_marker_tags(),
    shiny$tagList(
      bslib$card(
        height = "calc(100vh - 100px)",
        mm$mapOutput(ns("map")),
        make_top_cards$make_controls_ui(ns = ns),
        interactive_plot$interactive_plot_ui(id = ns("plot"))
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
      # these inputs are from the controls
      wrangle_data$get_poly_selection(
        layer_selection = input$layer_selection,
        seifa = input$seifa,
        remoteness = input$remoteness,
        itraqi_index = input$itraqi_index
      )
    })

    interactive_plot$interactive_plot_server(
      id = "plot",
      d_poly = d_poly,
      selected_layer = shiny$reactive({
        input$layer_selection
      }),
      proxy_map = proxymap()
    )

    shiny$observeEvent(list(proxymap(), d_poly(), input$layer_selection), {
      mm$update_map_shapes(
        proxy_map = proxymap(),
        d_selection = d_poly(),
        selected_layer = input$layer_selection,
        r_layers = shiny$isolate(layers_rv)
      )
    })


    shiny$observe({
      mm$update_map_markers(
        proxy_map = proxymap(),
        markers = input$base_layers
      )
    })

    shiny$observe({
      shiny$req(input$map_marker_click)
      mm$handle_marker_click(proxy_map = proxymap(), marker_click = input$map_marker_click)
    })

    shiny$observeEvent(input$map_click, {
      shiny$req(input$map_click)
      mm$add_prediction_marker(proxy_map = proxymap(), input$map_click)
    })
  })



  make_top_cards$make_controls_server(id)
}
