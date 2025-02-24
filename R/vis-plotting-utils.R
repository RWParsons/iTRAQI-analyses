get_plotting_utils <- function() {
  map_theme <- list(
    theme_minimal(),
    labs(x = "", y = ""),
    theme(
      panel.border = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_blank(),
      axis.text = element_blank()
    )
  )

  out_dpi <- 600

  add_common_plot_features <- function(gg,
                                       theme = map_theme,
                                       x_limits = c(135, 158),
                                       cities_data = other_cities,
                                       text_size = out_dpi / 300 * 12,
                                       add_dots_for_cities = T,
                                       text_hjust = -0.1,
                                       nudge_labels_x = 0) {
    gg <- gg +
      map_theme +
      geom_text(
        data = cities_data,
        aes(x = x, y = y, label = label),
        hjust = text_hjust,
        size = text_size,
        nudge_x = nudge_labels_x
      ) +
      scale_x_continuous(limits = x_limits)
    if (add_dots_for_cities) {
      gg <- gg + geom_point(data = cities_data, aes(x = x, y = y))
    }

    scale_legend <- list(
      y_bar = -29.4,
      y_text = -30,
      x_min = 147.69529500846323,
      x_max = 152.85606381166014,
      label_text = c("0", "500km")
    )

    d_rect <- bind_rows(
      c( # name = "full bar",
        ymin = scale_legend$y_bar - 0.1,
        ymax = scale_legend$y_bar,
        xmin = scale_legend$x_min,
        xmax = scale_legend$x_max
      ),
      c( # name = "tick_min",
        ymin = scale_legend$y_bar - 0.2,
        ymax = scale_legend$y_bar + 0.1,
        xmin = scale_legend$x_min,
        xmax = scale_legend$x_min - 0.1
      ),
      c( # name = "tick_min",
        ymin = scale_legend$y_bar - 0.2,
        ymax = scale_legend$y_bar + 0.1,
        xmin = scale_legend$x_max,
        xmax = scale_legend$x_max - 0.1
      )
    )

    gg +
      geom_rect(
        data = d_rect, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax)
      ) +
      geom_text(
        data = tibble(
          x = c(scale_legend$x_min, scale_legend$x_max),
          y = scale_legend$y_text,
          text = scale_legend$label_text
        ),
        aes(x = x, y = y, label = text), size = text_size
      )
  }

  other_cities <- data.frame(
    label = c("Brisbane", "Townsville", "Cairns", "Rockhampton", "Mackay", "Mount Isa"),
    x = c(153.0260, 146.8169, 145.7710, 150.5089, 149.1868, 139.4930),
    y = c(-27.4705, -19.2590, -16.9203, -23.3786, -21.1434, -20.7264)
  )

  list(
    map_theme = map_theme,
    other_cities = other_cities,
    add_common_plot_features = add_common_plot_features,
    qld_fill = "darkolivegreen3",
    out_dir = here::here("output/figures"),
    out_dpi = out_dpi,
    out_height = 7,
    out_width = 7
  )
}
