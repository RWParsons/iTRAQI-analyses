box::use(
  bslib,
  shiny,
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    shiny$tagList(
      bslib$card(
        shiny$uiOutput(ns("info_page"))
      )
    )
  )
}


#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    output$info_page <- shiny$renderUI({
      shiny$tags$iframe(
        seamless = "seamless", src = "static/iTRAQI_info.html",
        style = "width:calc(100vw - 50px);height:calc(100vh - 160px);"
      )
    })
  })
}
