box::use(
  bslib,
  shiny,
)

box::use(
  app / data / constants,
  app / logic / scales_and_palettes,
)


make_controls <- function(ns) {
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
              choices = c(
                "None",
                "SA1 Index",
                "SA2 Index",
                "Acute time",
                "SA1 Acute",
                "SA2 Acute",
                "Rehab time",
                "SA1 Rehab",
                "SA2 Rehab"
              ),
              selected = "None"
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
            ) # ,
            # htmlOutput(ns("seifa_included"))
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
            ) # ,
            # htmlOutput(ns("remoteness_included"))
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
            ) # ,
            # htmlOutput(ns("itraqi_included"))
          )
        )
      )
    )
  )
}
