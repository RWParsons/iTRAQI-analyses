# maps page
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
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    shiny$tagList(
      bslib$card(
        bslib$card_header(
          shinyWidgets$radioGroupButtons(
            ns("subtab"),
            choices = c("Tour", "Map")
          )
        ),
        height = "calc(100vh - 100px)",
        mm$mapOutput(ns("map"))
      )
    )
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$map <- mm$make_base_map(tour_map_content)

    content_added <- shiny$reactiveVal(value = FALSE)

    proxymap <- shiny$reactive(leaflet$leafletProxy("map"))

    map_content <- list(
      list(
        type = "polygon",
        polygon = shapes$sa1_polygons
      ),
      list(
        type = "linestring",
        linestring = shapes$sa1_linestring
      ),
      list(
        type = "linestring",
        linestring = shapes$sa2_linestring
      )
    )

    shiny$observe({
      if(content_added()) return()

      mm$add_map_content(proxymap(), map_content)

      content_added(TRUE)
    })


    shiny$observeEvent(input$subtab{
      browser()
    })

  })
}















