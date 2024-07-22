# main_map page
box::use(
  bslib,
  shiny,
  waiter,
  mapgl,
  strayr,
)


box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping / mapgl,
  app / view / main_map / interactive_plot,
  app / view / main_map / make_top_cards,
  app / logic / constants,
  app / logic / wrangle_data,
  app / logic / load_shapes,
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    # mm$prediction_marker_tags(),
    shiny$tagList(
      bslib$card(
        height = "calc(100vh - 100px)",
        # waiter$autoWaiter(html = waiter$spin_solar()),
        # mm$mapOutput(ns("map")),
        mapgl$mapboxglOutput(ns("map")),
        # make_top_cards$make_controls_ui(ns = ns),
        # interactive_plot$interactive_plot_ui(id = ns("plot")),
        shiny$sliderInput(ns("slider"), "min value:", value = 0, min = -3, max = 3),
        # shiny$absolutePanel(
        #   bottom = 5, left = 20,
        #   shiny$tags$div(constants$on_map_citation)
        # )
      )
    )
  )
}


#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$map <- mm$make_base_map()
    ns <- shiny$NS(id)

    # polygons <- load_shapes$stacked_sa1_sa2_polygon_geom |>
    #   dplyr::left_join(load_shapes$stacked_sa1_sa2_data, by = "CODE") |>
    #   dplyr::filter(SA_level == 2)
    #
    # polygons <- strayr$read_absmap("sa32021")
    # polygons$value_rehab <- stats::rnorm(n = nrow(polygons), mean = 100, sd = 30)
    #
    # output$map <- mapgl$renderMapboxgl({
    #   mapgl$mapboxgl(mapgl$mapbox_style("streets")) |>
    #     mapgl$fit_bounds(polygons, animate = FALSE) |>
    #     mapgl$add_fill_layer(id = "polygon_layer",
    #                          source = polygons,
    #                          fill_color = "blue",
    #                          fill_opacity = 0.5)
    # })


    # map_shapes <- strayr$read_absmap("sa32021") |>
    #   dplyr::rename(CODE = sa3_code_2021)
    # map_shapes$measure <- round(stats::rnorm(n = nrow(map_shapes)))

    # ns <- NS(id)
    # cat(ns('map'))



    # d <- load_shapes$stacked_sa1_sa2_polygon_geom |>
    #   dplyr::left_join(load_shapes$stacked_sa1_sa2_data, by = "CODE")


    # output$map <- mapgl$renderMapboxgl({
    #   mapgl$mapboxgl(mapgl$mapbox_style("streets")) |>
    #     mapgl$fit_bounds(load_shapes$state_boundary) |>
    #     mapgl$add_fill_layer(
    #       id = "polygons",
    #       source = d,
    #       fill_opacity = 0.5,
    #       fill_color = "blue",
    #       before_id = "tunnel-path"
    #     )
    # })


    # mapgl$renderMapboxgl(m)




    # output$map <- mapgl$renderMapboxgl({
    #   mapgl$mapboxgl(mapgl$mapbox_style("streets")) |>
    #     mapgl$fit_bounds(map_shapes, animate = FALSE) |>
    #     mapgl$add_fill_layer(id = "polygons",
    #                          source = map_shapes,
    #                          fill_color = "blue",
    #                          fill_opacity = 0.5)
    # })


    shiny$observe({
      input$slider

      mm$add_map_content(
        mm$get_map_proxy("map"),
        map_content = c(1,2)
      )


      # set_filter("your_layer_id", list("in", "your_column_name", input$select_input_id))



    })


    # proxymap <- shiny$reactive(mm$get_map_proxy("map"))
    # layers_rv <- shiny$reactiveValues(current_grp = "A", rasters = c())

    # d_poly <- shiny$reactive({
    #   # these inputs are from the controls
    #   wrangle_data$get_poly_selection(
    #     layer_selection = input$layer_selection,
    #     seifa = input$seifa,
    #     remoteness = input$remoteness,
    #     itraqi_index = input$itraqi_index
    #   )
    # })

    # interactive_plot$interactive_plot_server(
    #   id = "plot",
    #   d_poly = d_poly,
    #   selected_layer = shiny$reactive({
    #     input$layer_selection
    #   }),
    #   proxy_map = proxymap()
    # )


    # shiny$observe({
    #   mapgl$mapboxgl_proxy(ns("map")) |> # also works if using the ns()
    #     mapgl$set_filter(
    #       "polygon_layer",
    #       list(">=", mapgl$get_column("value_rehab"), input$slider)
    #     )
    # })

    # shiny$observeEvent(list(proxymap(), d_poly(), input$layer_selection), {
    #   mm$update_map_shapes(
    #     proxy_map = proxymap(),
    #     d_selection = d_poly(),
    #     selected_layer = input$layer_selection,
    #     r_layers = shiny$isolate(layers_rv)
    #   )
    # })


    # shiny$observe({
    #   mm$update_map_markers(
    #     proxy_map = proxymap(),
    #     markers = input$base_layers
    #   )
    # })

    # shiny$observe({
    #   shiny$req(input$map_marker_click)
    #   mm$handle_marker_click(proxy_map = proxymap(), marker_click = input$map_marker_click)
    # })

    # shiny$observeEvent(input$map_click, {
    #   shiny$req(input$map_click)
    #   mm$add_prediction_marker(proxy_map = proxymap(), input$map_click)
    # })
  })
  # make_top_cards$make_controls_server(id)
}

# mapboxgl_proxy <- function(mapId, session = shiny::getDefaultReactiveDomain()){
#   if (is.null(session)) {
#     stop("mapboxgl_proxy must be called from the server function of a Shiny app")
#   }
#   if (!is.null(session$ns) && nzchar(session$ns(NULL)) && substring(mapId, 1, nchar(session$ns(""))) != session$ns("")) {
#     mapId <- session$ns(mapId)
#   }
#   structure(
#     list(
#       session = session,
#       id = mapId,
#       deferUntilFlush = TRUE
#     ),
#     class = "mapboxgl_proxy"
#   )
# }
