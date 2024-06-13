box::use(
  bslib,
  shiny,
)

box::use(
  app / logic / constants,
  app / logic / scales_and_palettes,
  app / view / tour / card_content,
  app / view / tour / map_content,
  mm = app / mapping,
)


#' @export
make_tour_nav_card_ui <- function(ns) {
  shiny$absolutePanel(
    width = 400,
    top = 25,
    right = 35,
    shiny$uiOutput(ns("tour_card"))
  )
}


#' @export
make_tour_nav_card_server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {
    current_tour_tab <- shiny$reactiveVal(1)
    ns <- session$ns

    shiny$observeEvent(current_tour_tab(), {
      tour_card <- card_content$get_tour_card_content(tab = current_tour_tab())

      output$tour_card <- shiny$renderUI({
        if(current_tour_tab() == 1) {
          nav_buttons <- shiny$splitLayout(
            cellWidths = 180,
            NULL,
            shiny$actionButton(ns("nextTourTab"), "Next")
          )
        } else if(current_tour_tab() == card_content$n_tours) {
          nav_buttons <- shiny$splitLayout(
            cellWidths = 180,
            shiny$actionButton(ns("prevTourTab"), "Back"),
            NULL
          )
        } else {
          nav_buttons <- shiny$splitLayout(
            cellWidths = 180,
            shiny$actionButton(ns("prevTourTab"), "Back"),
            shiny$actionButton(ns("nextTourTab"), "Next")
          )
        }

        bslib$card(
          shiny$HTML(tour_card),
          nav_buttons
        )
      })

      mm$show_tour(
        proxy_map = proxy_map,
        tab = current_tour_tab(),
        map_content = map_content$get_map_layers(tab = current_tour_tab())
      )
    })


    # navigate tour forward and back
    shiny$observeEvent(input$nextTourTab, {
      current_tour_tab(current_tour_tab() + 1)
    })

    shiny$observeEvent(input$prevTourTab, {
      current_tour_tab(current_tour_tab() - 1)
    })

  })
}
