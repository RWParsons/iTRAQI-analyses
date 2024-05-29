# tour page

box::use(
  shiny,
  bslib,
  leaflet,
  strayr,
  sf,
  rdeck,
  leafgl,
  dplyr,
)

box::use(
  # mapping module - might change this to rdeck if it's possible - they will need to have
  # all the same functions in both modules so making generic names like "create map" and "update map" with generic inputs etc
  mm = app / mapping / leaflet
)



# sa1s_qld <- strayr$read_absmap("sa12021") |>
#   sf$st_transform(4326) |>
#   dplyr$filter(state_name_2021 == "Queensland") |>
#   dplyr$mutate(sa1_code_2021 = as.numeric(sa1_code_2021))


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)

  shiny$div(
    shiny$tagList(
      bslib$card(
        # main panel on right
        height = "calc(100vh - 100px)",
        mm$mapOutput(ns("map"))
        # leaflet$leafletOutput(ns("map"), width = "100%", height = "100%")
      )
    )
  )

  # if (pkg_use == "leaflet") {
  #   shiny$div(
  #     shiny$tagList(
  #       bslib$card(
  #         # main panel on right
  #         height = "calc(100vh - 100px)",
  #         mm$mapOutput(ns("map"))
  #         # leaflet$leafletOutput(ns("map"), width = "100%", height = "100%")
  #       )
  #     )
  #   )
  # } else if (pkg_use == "rdeck") {
  #   shiny$div(
  #     shiny$tagList(
  #       bslib$card(
  #         # main panel on right
  #         height = "calc(100vh - 100px)",
  #         rdeck$rdeckOutput(ns("map"), width = "100%", height = "100%")
  #       )
  #     )
  #   )
  # } else if (pkg_use == "leafgl") {
  #   shiny$div(
  #     shiny$tagList(
  #       bslib$card(
  #         # main panel on right
  #         height = "calc(100vh - 100px)",
  #         leafgl$leafglOutput(ns("map"))
  #       )
  #     )
  #   )
  # }
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    # output$map <- leaflet$renderLeaflet({
    #   leaflet$leaflet() |>
    #     leaflet$addTiles() |>
    #     leaflet$addPolygons(data = sa1s_qld, fillColor = "red")
    # })

    output$map <- mm$make_base_map()
  })
}
