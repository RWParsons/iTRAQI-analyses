create_app_rasters <- function(rehab, acute) {
  save_paths <- list(
    raster_points = file.path(output_dir, "raster_points.rds"),
    acute_raster = file.path(output_dir, "acute_raster.rds"),
    rehab_raster = file.path(output_dir, "rehab_raster.rds")
  )

  raster_points <- list(
    rehab_raster = as_tibble(rehab),
    acute_raster = as_tibble(acute)
  ) |>
    map(~ select(.x, x = X, y = Y, pred = var1.pred))

  saveRDS(raster_points, save_paths$raster_points)
}
