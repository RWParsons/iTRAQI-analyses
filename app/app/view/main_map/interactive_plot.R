box::use(
  bslib,
  shiny,
  ggplot2,
)


#' @export
interactive_plot_ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$absolutePanel(
    id = "plot_panel",
    class = "panel panel-default",
    fixed = TRUE,
    draggable = FALSE,
    top = 170,
    left = 50,
    right = "auto",
    bottom = "auto",
    width = 120,
    height = 50,
    shiny$checkboxInput(
      ns("show_plot_checkbox"),
      shiny$HTML("<b>Show plot</b>"),
      value = TRUE
    ),
    shiny$uiOutput(ns("plot_ui"))
  )
}

#' @export
interactive_plot_server <- function(id, d_poly) {
  shiny$moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$plot_ui <- shiny$renderUI({
      if (!input$show_plot_checkbox) {
        return()
      }


      shiny$plotOutput(
        ns("interactive_plot"),
        width = 500, height = 400
        # click = "plot_click",
        # brush = shiny$brushOpts("plot_brush")
      )
    })

    output$interactive_plot <- shiny$renderPlot({
      shiny$req(d_poly())
      cat(names(d_poly()$data))


      rehab_var <- ifelse(d_poly()$outcome == "rehab", "selected_col", "value_rehab")
      acute_var <- ifelse(d_poly()$outcome == "acute", "selected_col", "value_acute")

      d_poly()$data |>
        ggplot2$ggplot(ggplot2$aes(x = get(rehab_var), y = get(acute_var))) +
        ggplot2$geom_point()
    })
  })
}
