box::use(
  shiny,
  bslib,
)

box::use(
  app / view / main_map,
  app / view / tour,
  app / view / downloads,
  app / view / information,
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  bslib$page_navbar(
    # bslib$nav_panel(
    #   title = "Tour",
    #   tour$ui(ns("tour"))
    # ),
    bslib$nav_panel(
      title = "Maps",
      main_map$ui(ns("maps"))
    ),
    bslib$nav_panel(
      title = "Downloads",
      downloads$ui(ns("downloads"))
    ),
    bslib$nav_panel(
      title = "Information",
      information$ui(ns("information"))
    )
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    # tour$server("tour")
    main_map$server("maps")
    downloads$server("downloads")
    information$server("information")
  })
}
