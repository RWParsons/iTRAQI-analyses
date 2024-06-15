box::use(
  purrr,
  tidyterra,
)

box::use(
  app / logic / constants,
)

#' @export
state_boundary <- readRDS(file.path(constants$data_dir, "state_boundary.rds"))

#' @export
stacked_sa1_sa2_polygon_geom <- readRDS(file.path(
  constants$data_dir,
  "stacked_SA1_and_SA2_polygons_geom.rds"
))

#' @export
stacked_sa1_sa2_linestring_geom <- readRDS(file.path(
  constants$data_dir,
  "stacked_SA1_and_SA2_linestrings_geom.rds"
))

#' @export
stacked_sa1_sa2_data <- readRDS(file.path(
  constants$data_dir,
  "stacked_sa1_sa2_data.rds"
))

#' @export
raster_layers <- readRDS(file.path(constants$data_dir, "raster_points.rds")) |>
  purrr$map(~ tidyterra$as_spatraster(.x, crs = 4326))

#' @export
l_markers <- readRDS(file.path(constants$data_dir, "l_markers.rds"))
