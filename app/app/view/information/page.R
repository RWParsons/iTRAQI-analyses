box::use(
  bslib,
  here,
  shiny,
)

app_src_dir <- here$here("app/static")
app_data_dir <- here$here("app/data")

# pre-render the info page
if (!file.exists(file.path(app_src_dir, "iTRAQI_info.html"))) {
  rmarkdown$render(
    input = file.path(app_data_dir, "iTRAQI_info.md"),
    output_file = file.path(app_src_dir, "iTRAQI_info.html")
  )
}

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
