box::use(
  shiny,
  bslib,
)

box::use(
  app / view / maps
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  bslib$page_navbar(
    bslib$nav_panel(
      title = "Maps",
      maps$ui(ns("maps"))
    ) # ,

    # make more pages for main map, downloads and information.
    # bslib$nav_panel(
    #   title = "tour",
    #   tour$ui(ns("tour"))
    # )
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    maps$server("maps")
  })
}
