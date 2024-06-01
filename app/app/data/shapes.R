box::use(
  sf,
)

analyses_output_dir <- here::here("../output")

#' @export
sa1_polygon <- readRDS(file.path(analyses_output_dir, "sa1_polygon.rds"))

#' @export
sa1_linestring <- readRDS(file.path(analyses_output_dir, "sa1_linestring.rds"))

#' @export
sa2_linestring <- readRDS(file.path(analyses_output_dir, "sa2_linestring.rds"))

#' @export
stacked_sa1_sa2_data <- readRDS(file.path(analyses_output_dir, "stacked_sa1_sa2_data.rds"))

#' @export
sa1_sa2_code_lkp <- readRDS(file.path(analyses_output_dir, "sa1_sa2_code_lkp.rds"))

#' @export
sa_code_layerid_lkp <- readRDS(file.path(analyses_output_dir, "sa_code_layerid_lkp.rds"))

# TODO: later....
    # create a lookup between all filters and the layerids above so that layer ids
# can easily be selected based on selected filters
