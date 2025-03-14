box::use(
  bslib,
  dplyr,
  ggplot2,
  shiny,
  stringr,
)

box::use(
  app / logic / itraqi_categories_table,
  app / logic / scales_and_palettes,
  app / logic / utils,
  mm = app / mapping / leaflet,
)


#' @export
interactive_plot_ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$uiOutput(ns("interactive_plot_container"))
}

#' @export
interactive_plot_server <- function(id, d_poly, selected_layer, proxy_map) {
  shiny$moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$interactive_plot_container <- shiny$renderUI({
      shiny$req(selected_layer())

      if (stringr$str_detect(utils$get_standard_layer_name(selected_layer()), "sa[12]_")) {
        chkbox <- shiny$checkboxInput(
          ns("show_plot_checkbox"),
          shiny$HTML("<b>Show plot</b>"),
          value = FALSE
        )
      } else {
        chkbox <- NULL
      }

      shiny$absolutePanel(
        id = "plot_panel",
        class = "panel panel-default",
        fixed = TRUE,
        draggable = FALSE,
        top = 130,
        left = 150,
        right = "auto",
        bottom = "auto",
        width = 350,
        height = 50,
        chkbox,
        shiny$uiOutput(ns("plot_ui")),
        shiny$uiOutput(ns("itraqi_categories_table"))
      )
    })

    output$itraqi_categories_table <- shiny$renderUI({
      if (stringr$str_detect(utils$get_standard_layer_name(selected_layer()), "index")) {
        shiny$renderUI({
          bslib$card(itraqi_categories_table$itraqi_categories_table)
        })
      }
    })

    output$plot_ui <- shiny$renderUI({
      shiny$req(input$show_plot_checkbox)
      if (is.null(input$show_plot_checkbox)) {
        return()
      }
      if (!input$show_plot_checkbox) {
        return()
      }

      shiny$plotOutput(
        ns("interactive_plot"),
        width = 500,
        height = 400,
        click = ns("plot_click"),
        brush = shiny$brushOpts(ns("plot_brush"))
      )
    })

    shiny$observeEvent(list(input$plot_brush, input$plot_click), {
      shiny$req(d_poly())
      if (is.null(d_poly())) {
        return()
      }

      mm$clear_plot_interactions(proxy_map)

      d_plotted <- d_poly() |>
        back_trans_data() |>
        dplyr$filter(selected)


      mm$add_clicked_point(
        proxy_map = proxy_map,
        d_clicked = shiny$nearPoints(d_plotted, input$plot_click)[1, ]
      )

      mm$add_brushed_polylines(
        proxy_map = proxy_map,
        d_selection = shiny$brushedPoints(d_plotted, input$plot_brush)
      )
    })

    output$interactive_plot <- shiny$renderPlot({
      shiny$req(d_poly())

      col_vec <- scales_and_palettes$get_palette(d_poly()$outcome)(d_poly()$data$selected_col)

      d_poly() |>
        back_trans_data() |>
        ggplot2$ggplot(ggplot2$aes(x = rehab, y = acute, alpha = selected)) +
        ggplot2$geom_point(size = 2, col = col_vec) +
        ggplot2$theme_bw() +
        ggplot2$labs(
          y = "Acute time (minutes)",
          x = "Rehab time (minutes)"
        ) +
        ggplot2$scale_alpha_manual(values = c(0, 0.5), limits = c(FALSE, TRUE)) +
        ggplot2$scale_y_continuous(breaks = seq(0, 1000, by = 120), limits = c(0, NA)) +
        ggplot2$scale_x_continuous(breaks = seq(0, 1500, by = 120), limits = c(0, NA)) +
        ggplot2$theme(legend.position = "none")
    })
  })
}


back_trans_data <- function(d) {
  rehab_var <- ifelse(d$outcome == "rehab", "selected_col", "value_rehab")
  acute_var <- ifelse(d$outcome == "acute", "selected_col", "value_acute")

  if (is.null(d)) {
    return()
  }
  d$data |> dplyr$rename(rehab := rehab_var, acute := acute_var)
}
