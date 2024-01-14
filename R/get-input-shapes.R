get_input_shapes <- function(agg_grid_cellsize, raster_grid_cellsize) {
  qld_sa12021 <- strayr::read_absmap("sa12021") |>
    filter(state_name_2021 == "Queensland") |>
    st_transform(crs_for_analyses$crs_num)

  qld_sa12016 <- strayr::read_absmap("sa12016") |>
    filter(state_name_2016 == "Queensland") |>
    st_transform(crs_for_analyses$crs_num)

  qld_sa12011 <- strayr::read_absmap("sa12011") |>
    filter(state_name_2011 == "Queensland") |>
    st_transform(crs_for_analyses$crs_num)

  qld_sa1s_all <- bind_rows(
    select(qld_sa12021, code = 1),
    select(qld_sa12016, code = 1),
    select(qld_sa12011, code = 1)
  )

  qld_state_boundary <- qld_sa12021 |> summarize()
  qld_sp <- qld_state_boundary |> sf:::as_Spatial()

  qld_sa1s_centroids <- qld_sa1s_all |>
    st_point_on_surface() |>
    st_coordinates() |>
    as.data.frame() |>
    na.omit() |>
    st_as_sf(coords = c("X", "Y"), crs = crs_for_analyses$crs_num) |>
    st_transform(crs = crs_for_analyses$crs_num) |>
    st_coordinates()

  pnts_raster <- qld_sp |>
    sp::makegrid(cellsize = raster_grid_cellsize) |>
    st_as_sf(coords = c("x1", "x2"), crs = crs_for_analyses$crs_num) |>
    mutate(
      # https://gis.stackexchange.com/a/343479
      intersection = as.integer(st_intersects(geometry, qld_state_boundary))
    ) |>
    filter(!is.na(intersection)) |>
    st_coordinates() |>
    as.data.frame()
  sp::coordinates(pnts_raster) <- ~ X + Y

  pnts_agg <- qld_sp |>
    sp::makegrid(cellsize = agg_grid_cellsize) |>
    st_as_sf(coords = c("x1", "x2"), crs = crs_for_analyses$crs_num) |>
    mutate(
      # https://gis.stackexchange.com/a/343479
      intersection = as.integer(st_intersects(geometry, qld_state_boundary))
    ) |>
    filter(!is.na(intersection)) |>
    st_coordinates() |>
    as.data.frame() |>
    rbind(qld_sa1s_centroids)
  sp::coordinates(pnts_agg) <- ~ X + Y

  list(
    qld_state_boundary = qld_state_boundary,
    qld_pt_agg_grid = pnts_agg,
    qld_pt_raster_grid = pnts_raster
  )
}
