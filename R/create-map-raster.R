create_app_raster <- function(rehab, acute) {
  l <- list(
    rehab_raster = as_tibble(rehab),
    acute_raster = as_tibble(acute)
  ) |>
    map(~ rename(.x, x = X, y = Y))

  path <- file.path(output_dir, "raster_points.rds")

  saveRDS(l, path)
  path
}
