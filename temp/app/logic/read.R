box::use(
  here,
)

targets_output <- here::here("output")

#' @export
stacked_SA1_and_SA2_polygons <- readRDS(file.path(targets_output, "stacked_SA1_and_SA2_polygons.rds"))

