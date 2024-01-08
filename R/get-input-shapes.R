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
    filter(!is.na(sa2_centroid))

  qld_pt_agg_grid <- qld_state_boundary |>
    st_make_grid(cellsize = agg_grid_cellsize) |>
    st_centroid() |>
    st_as_sf() |>
    rename(geometry = x) |>
    add_column(sa2_centroid = 0) |>
    bind_rows(qld_sa2s_centroids) |> 
    st_intersection(qld_state_boundary)
  
  qld_pt_raster_grid <- qld_state_boundary |>
    st_make_grid(cellsize = raster_grid_cellsize) |>
    st_centroid() |>
    st_as_sf() |>
    rename(geometry = x) |> 
    st_intersection(qld_state_boundary)

  list(
    qld_sa22021 = qld_sa22021,
    qld_sa22016 = qld_sa22016,
    qld_sa22011 = qld_sa22011,
    qld_state_boundary = qld_state_boundary,
    qld_pt_agg_grid = qld_pt_agg_grid,
    qld_pt_raster_grid = qld_pt_raster_grid
  )
}
