aggregate_kriging_model_to_ASGS <- function(kriged_spdf, ASGS_level, ASGS_year) {
  SA_id <- glue::glue("{ASGS_level}_CODE{ASGS_year}")

  kriged_sf <- st_as_sf(kriged_spdf)
  kriged_sf <- st_set_crs(kriged_sf, crs_for_analyses$crs_num)
  kriged_sf <- st_transform(kriged_sf, crs = crs_for_analyses$crs_num)

  ASGS_poly <- strayr::read_absmap(area = ASGS_level, year = ASGS_year) |>
    (\(x) x[!st_is_empty(x), ])() |>
    filter(!!rlang::sym(glue::glue("state_name_{ASGS_year}")) == "Queensland") |>
    st_transform(crs = crs_for_analyses$crs_num) |>
    select(!!SA_id := 1)

  qld_SAs_with_int_times <- st_join(ASGS_poly, kriged_sf)

  SAs_agg_times <-
    qld_SAs_with_int_times |>
    na.omit() |>
    as.data.frame() |>
    group_by(across(all_of(SA_id))) |>
    summarize(
      value = median(var1.pred, na.rm = TRUE),
      min = min(var1.pred, na.rm = TRUE),
      max = max(var1.pred, na.rm = TRUE)
    ) |>
    remove_rownames()

  stopifnot(assertthat::are_equal(nrow(ASGS_poly), nrow(SAs_agg_times)))

  SAs_agg_times
}
