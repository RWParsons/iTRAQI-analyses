box::use(
  shiny,
  bslib,
)

box::use(
  app / view / main_map,
  app / view / downloads,
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  bslib$page_navbar(
    bslib$nav_panel(
      title = "Downloads",
      downloads$ui(ns("downloads"))
    ),
    bslib$nav_panel(
      title = "Maps",
      main_map$ui(ns("maps"))
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
    main_map$server("maps")
    downloads$server("downloads")
  })
}
