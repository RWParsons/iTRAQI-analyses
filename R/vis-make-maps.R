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
