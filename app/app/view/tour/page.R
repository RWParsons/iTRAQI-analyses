box::use(
  bslib,
  leaflet,
  shiny,
  waiter,
)

box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping / leaflet,
  app / logic / constants,
  app / view / tour / tour_navigation,
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
        tour_navigation$make_tour_nav_ui(id = ns("nav")),
        shiny$absolutePanel(
          bottom = 15, left = 20,
          shiny$tags$div(constants$on_map_citation)
        )
      )
    )
  )
}



#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$map <- mm$make_base_map(show_default_markers = FALSE)
    proxymap <- shiny$reactive(leaflet$leafletProxy("map"))
    tour_navigation$make_tour_nav_server(id = "nav", proxymap())
  })
}
