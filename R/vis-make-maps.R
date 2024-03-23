make_qas_map <- function(shapes, utils) {
  p <- ggplot() +
    geom_sf(data = shapes$qld_boundary, fill = utils$qld_fill, col = "transparent") +
    geom_point(data = shapes$qas_locations, aes(x = x, y = y), shape = 3, col = "red", size = 0.6)

  p <- utils$add_common_plot_features(p)
  file_path <- file.path(utils$out_dir, "qas_locations.jpeg")
  ggsave(plot = p, file_path, height = utils$out_height, width = utils$out_width, dpi = utils$out_dpi)

  file_path
}

make_towns_map <- function(shapes, utils) {
  p <- ggplot() +
    geom_sf(data = shapes$qld_boundary, fill = utils$qld_fill, col = "transparent") +
    geom_point(data = shapes$town_locations, aes(x = x, y = y), col = "blue")

  p <- utils$add_common_plot_features(p)
  file_path <- file.path(utils$out_dir, "town_locations.jpeg")
  ggsave(plot = p, file_path, height = utils$out_height, width = utils$out_width, dpi = utils$out_dpi)

  file_path
}

make_rsq_maps <- function(shapes, utils) {
  p <- ggplot() +
    geom_sf(data = shapes$qld_boundary, fill = utils$qld_fill, col = "transparent") +
    geom_text(
      data = filter(shapes$rsq_locations, method == "plane"),
      aes(x = x, y = y, label = fontawesome("fa-plane")),
      size = utils$out_dpi / 300 * 15,
      family = "fontawesome-webfont"
    )

  p <- utils$add_common_plot_features(p, add_dots_for_cities = FALSE)
  fixed_wing_file_path <- file.path(utils$out_dir, "rsq-fixed-wing_locations.jpeg")
  ggsave(plot = p, fixed_wing_file_path, height = utils$out_height, width = utils$out_width, dpi = utils$out_dpi)

  p <- ggplot() +
    geom_sf(data = shapes$qld_boundary, fill = utils$qld_fill, col = "transparent") +
    geom_text(
      data = filter(shapes$rsq_locations, method == "helicopter"),
      aes(x = x, y = y, label = emoji("helicopter")),
      size = utils$out_dpi / 300 * 15,
      vjust = 0,
      family = "EmojiOne"
    )

  p <- utils$add_common_plot_features(p, add_dots_for_cities = FALSE)
  helicopter_file_path <- file.path(utils$out_dir, "rsq-helicopter_locations.jpeg")
  ggsave(plot = p, helicopter_file_path, height = utils$out_height, width = utils$out_width, dpi = utils$out_dpi)

  c(fixed_wing_file_path, helicopter_file_path)
}

make_major_regional_services_map <- function(shapes, utils) {
  p <- ggplot() +
    geom_sf(data = shapes$qld_boundary, fill = utils$qld_fill, col = "transparent") +
    geom_point(data = shapes$rehab_service_cats, aes(x = x, y = y, shape = type, col = type, size = type)) +
    scale_shape_manual(values = c(10, 1)) +
    scale_colour_manual(values = c("red", "blue")) +
    scale_size_manual(values = c(3, 1))

  p <- utils$add_common_plot_features(p, add_dots_for_cities = F) +
    theme(legend.position = "none")

  file_path <- file.path(utils$out_dir, "major-and-regional-rehab-services.jpeg")
  ggsave(plot = p, file_path, height = utils$out_height, width = utils$out_width, dpi = utils$out_dpi)
  file_path
}

make_inset_maps <- function(shapes, centre_coords, utils, medal_icon_paths) {
  inset_limits <- list(
    x = c(152.9, 154.18),
    y = c(-28, -26.75)
  )

  # new filters for centres:
  centres_keep <- c(
    "Townsville University Hospital",
    "Sunshine Coast University Hospital",
    "Surgical, Treatment and Rehabilitation Service (STARS)",
    "Princess Alexandra Hospital (PAH)",
    "Gold Coast University Hospital"
  )


  rehab_centres_df <- centre_coords |>
    mutate(rehab_level = ifelse(str_detect(tolower(centre_name), "pah|townsville"), "gold", "silver")) |>
    arrange(centre_name) |>
    select(centre_name, x, y, rehab_level) |>
    mutate(icon = ifelse(rehab_level == "gold", medal_icon_paths$gold, medal_icon_paths$silver)) |>
    filter(centre_name %in% centres_keep)


  p <-
    ggplot() +
    geom_sf(data = shapes$qld_boundary, fill = utils$qld_fill, col = "transparent") +
    ggstar::geom_star(
      data = filter(rehab_centres_df, rehab_level == "silver"),
      aes(x = x, y = y),
      starshape = 1,
      size = 3,
      fill = "grey"
    ) +
    ggstar::geom_star(
      data = filter(rehab_centres_df, rehab_level == "gold"),
      aes(x = x, y = y),
      starshape = 1,
      size = 3,
      fill = "gold"
    )

  p1 <- utils$add_common_plot_features(p, add_dots_for_cities = F) +
    geom_rect(
      aes(
        xmin = inset_limits$x[1], xmax = inset_limits$x[2],
        ymin = inset_limits$y[1], ymax = inset_limits$y[2]
      ),
      fill = "transparent", color = "black", linewidth = 1
    )

  p1

  rehab_centres_labels <-
    rehab_centres_df %>%
    rename(label = centre_name)

  p2 <-
    utils$add_common_plot_features(
      p,
      cities_data = rehab_centres_labels,
      add_dots_for_cities = F,
      text_hjust = 0,
      text_size = utils$out_dpi / 300 * 14,
      nudge_labels_x = 0.03
    ) +
    coord_sf(
      xlim = inset_limits$x,
      ylim = inset_limits$y
    ) +
    theme(
      panel.border = element_rect(color = "black", fill = NA, linewidth = 2)
    )


  rehab_services_inset_path <- file.path(utils$out_dir, "rehab-services-inset-map-18pt.jpeg")
  p2
  ggsave(rehab_services_inset_path, height = utils$out_height, width = utils$out_width * 2, dpi = utils$out_dpi)


  rehab_services_inset_combined_path <- file.path(utils$out_dir, "rehab-services-inset-map-combined.jpeg")
  cowplot::ggdraw(p1) + cowplot::draw_plot(p2, x = 0.455, y = 0.27, width = 0.73, height = 0.73)
  ggsave(rehab_services_inset_combined_path, height = utils$out_height, width = utils$out_width * 2, dpi = utils$out_dpi)

  c(
    rehab_services_inset_path,
    rehab_services_inset_combined_path
  )
}
