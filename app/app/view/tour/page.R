box::use(
  bslib,
  leaflet,
  shiny,
  waiter,
)

box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping,
  app / view / tour / tour_navigation,
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
        waiter$autoWaiter(html = waiter$spin_solar()),
        mm$mapOutput(ns("map")),
        tour_navigation$make_tour_nav_ui(id = ns("nav"))
      )
    )
  )
}



#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$map <- mm$make_base_map(show_default_markers = FALSE)
    proxymap <- shiny$reactive(leaflet$leafletProxy("map"))
    # layers_rv <- shiny$reactiveValues(current_grp = "A", rasters = c())
    tour_navigation$make_tour_nav_server(id = "nav", proxymap())
  })
}
