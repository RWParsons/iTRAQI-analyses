get_input_shapes <- function(agg_grid_cellsize, raster_grid_cellsize) {
  qld_sa22021 <- strayr::read_absmap("sa22021") |>
    filter(state_name_2021 == "Queensland")

  qld_sa22016 <- strayr::read_absmap("sa22016") |>
    filter(state_name_2016 == "Queensland")

  qld_sa22011 <- strayr::read_absmap("sa22011") |>
    filter(state_name_2011 == "Queensland")

  qld_sa2s_all <- bind_rows(
    select(qld_sa22021, code = 1),
    select(qld_sa22016, code = 1),
    select(qld_sa22011, code = 1)
  )

  qld_state_boundary <- qld_sa22021 |> summarize()

  qld_boundary <- read_sf("data/qld_state_polygon_shp/QLD_STATE_POLYGON_shp.shp")
  grid_crs <- st_crs(qld_boundary)

  aus <- raster::getData("GADM", country = "AUS", level = 1)

  qld_sa2s_centroids <- qld_sa2s_all |>
    st_point_on_surface() |>
    st_coordinates() |>
    as.data.frame() |>
    na.omit() |>
    st_as_sf(coords = c("X", "Y"), crs = st_crs(qld_state_boundary)) |>
    (\(x){
      x$sa2_centroid <- as.integer(st_intersects(x$geometry, qld_state_boundary))
      x
    })() |>
    filter(!is.na(sa2_centroid)) |>
    st_transform(crs = st_crs(aus)) |>
    st_coordinates()

  pnts_raster <- aus[aus$NAME_1 == "Queensland", ] |>
    sp::makegrid(cellsize = raster_grid_cellsize) |>
    st_as_sf(coords = c("x1", "x2"), crs = st_crs(qld_boundary)) |>
    mutate(
      # https://gis.stackexchange.com/a/343479
      intersection = as.integer(st_intersects(geometry, qld_boundary))
    ) |>
    filter(!is.na(intersection)) |>
    st_coordinates() |>
    as.data.frame()
  sp::coordinates(pnts_raster) <- ~ X + Y

  pnts_agg <- aus[aus$NAME_1 == "Queensland", ] |>
    sp::makegrid(cellsize = agg_grid_cellsize) |>
    st_as_sf(coords = c("x1", "x2"), crs = st_crs(qld_boundary)) |>
    mutate(
      # https://gis.stackexchange.com/a/343479
      intersection = as.integer(st_intersects(geometry, qld_boundary))
    ) |>
    filter(!is.na(intersection)) |>
    st_coordinates() |>
    as.data.frame() |>
    rbind(qld_sa2s_centroids)
  sp::coordinates(pnts_agg) <- ~ X + Y

  list(
    qld_sa22021 = qld_sa22021,
    qld_sa22016 = qld_sa22016,
    qld_sa22011 = qld_sa22011,
    qld_state_boundary = qld_state_boundary,
    qld_pt_agg_grid = pnts_agg,
    qld_pt_raster_grid = pnts_raster,
    grid_crs = grid_crs
  )
}
