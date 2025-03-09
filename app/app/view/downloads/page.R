box::use(
  bslib,
  shiny,
  shinyWidgets,
)

box::use(
  app / logic / constants,
)


#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    shiny$tagList(
      bslib$card(
        height = "calc(100vh - 100px)",
        shiny$tags$h3("Download links PDF versions of maps:"),
        shinyWidgets$downloadBttn(ns("download_SA1_pdf"), "Download SA1 PDF", style = "pill", block = FALSE),
        shinyWidgets$downloadBttn(ns("download_SA2_pdf"), "Download SA2 PDF", style = "pill", block = FALSE),
        shiny$tags$h3("Download links for SA1 and SA2 aggregate time to care:"),
        shiny$tags$h4("2011 Australian Statistical Geography Standard (ASGS) Statistical Areas level 1 and 2 (SA1 and SA2):"),
        shinyWidgets$downloadBttn(ns("download_SA1_2011"), "Download (2011 SA1s)", style = "pill", block = FALSE),
        shinyWidgets$downloadBttn(ns("download_SA2_2011"), "Download (2011 SA2s)", style = "pill", block = FALSE),
        shiny$tags$br(),
        shiny$tags$br(),
        shiny$tags$h4("2016 ASGS SA1 and SA2:"),
        shinyWidgets$downloadBttn(ns("download_SA1_2016"), "Download (2016 SA1s)", style = "pill", block = FALSE),
        shinyWidgets$downloadBttn(ns("download_SA2_2016"), "Download (2016 SA2s)", style = "pill", block = FALSE),
        shiny$tags$br(),
        shiny$tags$br(),
        shiny$tags$h4("2021 ASGS SA1 and SA2:"),
        shinyWidgets$downloadBttn(ns("download_SA1_2021"), "Download (2021 SA1s)", style = "pill", block = FALSE),
        shinyWidgets$downloadBttn(ns("download_SA2_2021"), "Download (2021 SA2s)", style = "pill", block = FALSE)
      )
    )
  )
}



#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    download_data_files <- list(
      SA1_PDF = "SA1-maps.pdf",
      SA2_PDF = "SA2-maps.pdf",
      SA1_2011 = "iTRAQI - ASGS 2011 SA1.xlsx",
      SA2_2011 = "iTRAQI - ASGS 2011 SA2.xlsx",
      SA1_2016 = "iTRAQI - ASGS 2016 SA1.xlsx",
      SA2_2016 = "iTRAQI - ASGS 2016 SA2.xlsx",
      SA1_2021 = "iTRAQI - ASGS 2021 SA1.xlsx",
      SA2_2021 = "iTRAQI - ASGS 2021 SA2.xlsx"
    )

    # PDFs
    output$download_SA1_pdf <- shiny$downloadHandler(
      filename = download_data_files$SA1_PDF,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA1_PDF), file)
      }
    )

    output$download_SA2_pdf <- shiny$downloadHandler(
      filename = download_data_files$SA2_PDF,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA2_PDF), file)
      }
    )

    # Data
    output$download_SA1_2011 <- shiny$downloadHandler(
      filename = download_data_files$SA1_2011,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA1_2011), file)
      }
    )

    output$download_SA2_2011 <- shiny$downloadHandler(
      filename = download_data_files$SA2_2011,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA2_2011), file)
      }
    )

    output$download_SA1_2016 <- shiny$downloadHandler(
      filename = download_data_files$SA1_2016,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA1_2016), file)
      }
    )

    output$download_SA2_2016 <- shiny$downloadHandler(
      filename = download_data_files$SA2_2016,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA2_2016), file)
      }
    )

    output$download_SA1_2021 <- shiny$downloadHandler(
      filename = download_data_files$SA1_2021,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA1_2021), file)
      }
    )

    output$download_SA2_2021 <- shiny$downloadHandler(
      filename = download_data_files$SA2_2021,
      content = function(file) {
        file.copy(file.path(constants$downloads_dir, download_data_files$SA2_2021), file)
      }
    )
  })
}
