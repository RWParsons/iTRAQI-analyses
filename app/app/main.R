box::use(
  shiny,
  bslib,
)

box::use(
  app / view / tour
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  # bootstrapPage(
  #   uiOutput(ns("message"))
  # )

  bslib$page_navbar(
    bslib$nav_panel(
      title = "tour",
      tour$ui(ns("tour"))
    )
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    tour$server("tour")

    # output$message <- renderUI({
    #   div(
    #     style = "display: flex; justify-content: center; align-items: center; height: 100vh;",
    #     tags$h1(
    #       tags$a("Check out Rhino docs!", href = "https://appsilon.github.io/rhino/")
    #     )
    #   )
    # })
  })
}
