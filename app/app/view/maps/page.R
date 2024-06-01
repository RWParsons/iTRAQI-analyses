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
        bslib$card_header(
          shinyWidgets$radioGroupButtons(
            ns("map-tab"),
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
    tour_map_content <- list(
      list(
        type = "polygon",
        data = shapes$qld_sa1s
      )
    )
    output$map <- mm$make_base_map(tour_map_content)
  })
}
