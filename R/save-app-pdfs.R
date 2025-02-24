make_app_pdfs <- function(iTRAQI_list, utils) {
  # iTRAQI_list <- itraqi_list
  # utils <- plotting_utils

  tsize <- 2

  plot_with_continuous_legend <- ggplot() +
    geom_tile(
      data = iTRAQI_list$rehab_raster,
      aes(x = x, y = y, fill = (pred / 60))
    ) +
    coord_equal() +
    scale_fill_gradientn(
      colours = iTRAQI_list$palNum_hours(iTRAQI_list$bins / 60),
      values = scales::rescale(iTRAQI_list$bins / 60),
      breaks = seq(0, 20, 2),
      guide = guide_colourbar(reverse = TRUE, ticks.colour = NA)
    ) +
    labs(fill = "Travel time \n(hours)") +
    theme(legend.key.height = unit(2, "line"), legend.justification.inside = c(1, 1))

  grb_continuous_legend <- cowplot::get_legend(plot_with_continuous_legend)

  iTRAQI_pal_vec <- iTRAQI_list$paliTRAQI(iTRAQI_list$iTRAQI_bins)
  names(iTRAQI_pal_vec) <- iTRAQI_list$iTRAQI_bins

  plot_with_index_legend <- ggplot() +
    geom_sf(data = iTRAQI_list$qld_SA2s, aes(fill = index)) +
    scale_fill_manual(values = iTRAQI_pal_vec, breaks = sort(names(iTRAQI_pal_vec))) +
    labs(fill = "iTRAQI Index")


  itraqi_legend <- cowplot::get_legend(plot_with_index_legend)


  p_itraqi <- ggplot() +
    geom_sf(
      data = iTRAQI_list$qld_SA2s, fill = iTRAQI_list$paliTRAQI(iTRAQI_list$qld_SA2s$index)
    )
  p_itraqi <- utils$add_common_plot_features(p_itraqi, add_dots_for_cities = F, text_size = tsize)

  p1 <- ggplot() +
    geom_sf(
      data = iTRAQI_list$qld_SA2s, fill = iTRAQI_list$palNum(iTRAQI_list$qld_SA2s$value_rehab)
    )

  p2 <- ggplot() +
    geom_sf(
      data = iTRAQI_list$qld_SA2s, fill = iTRAQI_list$palNum(iTRAQI_list$qld_SA2s$value_rehab)
    )

  p3 <- ggplot() +
    geom_sf(
      data = iTRAQI_list$qld_SA2s, fill = iTRAQI_list$palNum(iTRAQI_list$qld_SA2s$value_rehab)
    )

  p4 <- ggplot() +
    geom_sf(
      data = iTRAQI_list$qld_SA2s, fill = iTRAQI_list$palNum(iTRAQI_list$qld_SA2s$value_rehab)
    )

  legend_panel <- cowplot::plot_grid(NULL, grb_continuous_legend, NULL, ncol = 1, rel_heights = c(0.5, 0.3, 0.5))

  ps <- list(p1, p2, p3, p4) |>
    map(~ utils$add_common_plot_features(.x, add_dots_for_cities = F, text_size = tsize))


  p_right_plots <- cowplot::plot_grid(
    ps[[1]], NULL, ps[[2]],
    NULL, NULL, NULL,
    ps[[3]], NULL, ps[[4]],
    rel_heights = c(2, -1, 2),
    rel_widths = c(2, -0.2, 2),
    nrow = 3
  )

  p_right_side <- cowplot::plot_grid(p_right_plots, legend_panel, rel_widths = c(0.9, 0.2))

  p_left_side <- cowplot::plot_grid(NULL, itraqi_legend, p_itraqi, nrow = 1, rel_widths = c(0.1, 0.1, 0.9))

  cowplot::plot_grid(p_left_side, p_right_side)

  ggsave(file = "output/figures/SA1-maps.pdf", width = 297, height = 210, units = "mm")
}
