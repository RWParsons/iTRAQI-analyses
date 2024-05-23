# tour page

box::use(
  shiny,
  bslib,
  leaflet
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)

  shiny$div(
    shiny$tagList(
      bslib$card(
        # main panel on right
        height = "calc(100vh - 100px)",
        leaflet$leafletOutput(ns("map"), width = "100%", height = "100%")
      )
    )
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$map <- leaflet$renderLeaflet({
      leaflet$leaflet() |>
        leaflet$addTiles()
    })
  })
}
