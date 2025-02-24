box::use(
  bslib,
  shiny,
  stringr,
)

box::use(
  app / logic / constants,
  app / logic / scales_and_palettes,
)

#' @export
make_controls_ui <- function(ns) {
  shiny$absolutePanel(
    width = 400,
    top = 25,
    right = 35,
    bslib$accordion(
      open = FALSE,
      bslib$accordion_panel(
        "Controls",
        open = FALSE,
        bslib$accordion(
          open = FALSE,
          bslib$accordion_panel(
            "Layer",
            shiny$radioButtons(
              inputId = ns("layer_selection"),
              label = NULL,
              choices = names(constants$layer_choices),
              selected = names(constants$layer_choices)[1]
            )
          ),
          bslib$accordion_panel(
            "Markers",
            shiny$actionButton(
              ns("base_layers_all_btn"),
              label = "(de)select all",
              status = "primary",
              size = "sm"
            ),
            shiny$HTML("<br><br>"),
            shiny$checkboxGroupInput(
              inputId = ns("base_layers"),
              label = NULL,
              choices = constants$all_base_layers,
              selected = constants$default_base_layers
            )
          ),
          bslib$accordion_panel(
            "SEIFA",
            shiny$actionButton(
              ns("seifa_all_btn"),
              label = "(de)select all",
              status = "primary",
              size = "sm"
            ),
            shiny$HTML("<br><br>"),
            shiny$checkboxGroupInput(
              inputId = ns("seifa"),
              label = NULL,
              choices = scales_and_palettes$seifa_text_choices,
              selected = scales_and_palettes$seifa_text_choices
            ),
            shiny$htmlOutput(ns("seifa_included"))
          ),
          bslib$accordion_panel(
            "Remoteness index",
            shiny$actionButton(
              ns("remoteness_all_btn"),
              label = "(de)select all",
              status = "primary",
              size = "sm"
            ),
            shiny$HTML("<br><br>"),
            shiny$checkboxGroupInput(
              inputId = ns("remoteness"),
              label = NULL,
              choices = scales_and_palettes$ra_text_choices,
              selected = scales_and_palettes$ra_text_choices
            ),
            shiny$htmlOutput(ns("remoteness_included"))
          ),
          bslib$accordion_panel(
            "iTRAQI index",
            shiny$actionButton(
              ns("itraqi_all_btn"),
              label = "(de)select all",
              status = "primary",
              size = "sm"
            ),
            shiny$HTML("<br><br>"),
            shiny$checkboxGroupInput(
              inputId = ns("itraqi_index"),
              label = NULL,
              choices = scales_and_palettes$iTRAQI_levels,
              selected = scales_and_palettes$iTRAQI_levels
            ),
            shiny$htmlOutput(ns("itraqi_index_included"))
          )
        )
      )
    )
  )
}


#' @export
make_controls_server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    # base layers
    shiny$observeEvent(input$base_layers_all_btn, {
      if (length(input$base_layers) != length(constants$all_base_layers)) {
        shiny$updateCheckboxGroupInput(
          inputId = "base_layers",
          selected = constants$all_base_layers
        )
      } else {
        shiny$updateCheckboxGroupInput(
          inputId = "base_layers",
          choices = constants$all_base_layers,
          selected = NULL
        )
      }
    })

    # SEIFA
    output$seifa_included <- shiny$renderText({
      if (length(input$seifa) == 0) {
        return("<b>All excluded</b>")
      } else if (length(input$seifa) == length(scales_and_palettes$seifa_text_choices)) {
        return("<b>All included</b>")
      } else {
        paste("<b>Including:</b>", paste0(input$seifa, collapse = ", "))
      }
    })
    shiny$observeEvent(input$seifa_all_btn, {
      if (length(input$seifa) != length(scales_and_palettes$seifa_text_choices)) {
        shiny$updateCheckboxGroupInput(
          inputId = "seifa",
          selected = scales_and_palettes$seifa_text_choices
        )
      } else {
        shiny$updateCheckboxGroupInput(
          inputId = "seifa",
          choices = scales_and_palettes$seifa_text_choices,
          selected = NULL
        )
      }
    })

    # Remoteness
    output$remoteness_included <- shiny$renderText({
      if (length(input$remoteness) == 0) {
        return("<b>All excluded</b>")
      } else if (length(input$remoteness) == length(scales_and_palettes$ra_text_choices)) {
        return("<b>All included</b>")
      } else {
        paste("<b>Including:</b>", paste0(input$remoteness, collapse = ", "))
      }
    })
    shiny$observeEvent(input$remoteness_all_btn, {
      if (length(input$remoteness) != length(scales_and_palettes$ra_text_choices)) {
        shiny$updateCheckboxGroupInput(
          inputId = "remoteness",
          selected = scales_and_palettes$ra_text_choices
        )
      } else {
        shiny$updateCheckboxGroupInput(
          inputId = "remoteness",
          choices = scales_and_palettes$ra_text_choices,
          selected = NULL
        )
      }
    })

    # iTRAQI index
    output$itraqi_index_included <- shiny$renderText({
      if (length(input$itraqi_index) == 0) {
        return("<b>All excluded</b>")
      } else if (length(input$itraqi_index) == length(scales_and_palettes$iTRAQI_levels)) {
        return("<b>All included</b>")
      } else {
        paste("<b>Including:</b>", paste0(input$itraqi_index, collapse = ", "))
      }
    })
    shiny$observeEvent(input$itraqi_all_btn, {
      if (length(input$itraqi_index) != length(scales_and_palettes$iTRAQI_levels)) {
        shiny$updateCheckboxGroupInput(
          inputId = "itraqi_index",
          selected = scales_and_palettes$iTRAQI_levels
        )
      } else {
        shiny$updateCheckboxGroupInput(
          inputId = "itraqi_index",
          choices = scales_and_palettes$iTRAQI_levels,
          selected = NULL
        )
      }
    })
  })
}
