box::use(
  sf,
  dplyr,
)


analyses_output_dir <- here::here("../output")

#' @export
qld_sa1s <- readRDS(file.path(analyses_output_dir, "stacked_SA1_and_SA2_polygons.rds")) |>
  dplyr$filter(SA_level == 1) |>
  sf$st_cast("MULTIPOLYGON") |>
  sf$st_cast("POLYGON")
