box::use(
  sf,
  dplyr,
)

analyses_output_dir <- here::here("../output")

#' @export
sa1_polygons <- readRDS(file.path(analyses_output_dir, "sa1_polygon.rds"))

#' @export
sa1_linestring <- readRDS(file.path(analyses_output_dir, "sa1_linestring.rds"))

#' @export
sa2_linestring <- readRDS(file.path(analyses_output_dir, "sa2_linestring.rds"))

#' @export
stacked_sa1_sa2_data <- readRDS(file.path(analyses_output_dir, "stacked_sa1_sa2_data.rds"))

#' @export
sa1_sa2_code_lkp <- readRDS(file.path(analyses_output_dir, "sa1_sa2_code_lkp.rds"))


linestring_layerid_lkp <- bind_rows(sa1_linestring, sa2_linestring) |>
  as_tibble() |>
  select(-geometry) |>
  mutate(type = "linestring")

# TODO: create big lookup table for
    # - codes (SA1s and SA2s)
    # - the layer type ("polygon" or "linestring")
    # - the layerid that will be assigned for updating aesthetics (and possibly
    #   used straight up as a group for showing/hiding)


# TODO: later....
    # create a lookup between all filters and the layerids above so that layer ids
# can easily be selected based on selected filters
