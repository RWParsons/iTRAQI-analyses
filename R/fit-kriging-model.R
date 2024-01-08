do_kriging_model <- function(points, data, formula, grid_crs, get_raster = TRUE) {
  data_sp <- data
  sp::coordinates(data_sp) <- ~ x + y
  lzn_vgm <- gstat::variogram(formula, data = data_sp)
  lzn_fit <- gstat::fit.variogram(lzn_vgm, model = gstat::vgm("Sph"))

  kriged_layer <- gstat::krige(formula, data_sp, points, model = lzn_fit)

  if (get_raster) {
    kriged_raster <- raster::rasterFromXYZ(kriged_layer, crs = grid_crs)
    return(list(
      kriged_layer = kriged_layer,
      kriged_raster = kriged_raster
    ))
  }

  list(kriged_layer = kriged_layer)
}
