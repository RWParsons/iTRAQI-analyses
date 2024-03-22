get_vis_datasets <- function(polygons,
                             qld_boundary,
                             centre_coords,
                             qas_locations,
                             rsq_locations,
                             town_locations,
                             centre_icons) {
  polygons <-
    readRDS(polygons) |>
    mutate(
      acute_range = str_extract(popup_acute, "(?<=[0-9] )\\[.*\\]"),
      acute_range = str_remove_all(acute_range, "\\[|\\]")
    ) |>
    separate(acute_range, c("acute_min", "acute_max"), sep = " - ") |>
    mutate(across(c("acute_min", "acute_max"), as.numeric)) |>
    mutate(
      rehab_range = str_extract(popup_rehab, "(?<=[0-9] )\\[.*\\]"),
      rehab_range = str_remove_all(rehab_range, "\\[|\\]")
    ) |>
    separate(rehab_range, c("rehab_min", "rehab_max"), sep = " - ") |>
    mutate(across(c("rehab_min", "rehab_max"), as.numeric))


  qld_SA2s <- polygons |> filter(SA_level == 2)
  qld_SA1s <- polygons |> filter(SA_level == 1)

  rehab_centres <- centre_coords |>
    filter(care_type == "rehab") |>
    mutate(img = centre_icons$rehab$iconUrl)


  rsq_locations_long <- rsq_locations |>
    mutate(
      plane = ifelse(type %in% c("plane", "both"), 1, 0),
      helicopter = ifelse(type %in% c("helicopter", "both"), 1, 0)
    ) |>
    pivot_longer(cols = c(plane, helicopter), names_to = "method") |>
    filter(value == 1)

  list(
    polygons = polygons,
    qld_boundary = qld_boundary,
    qld_SA2s = qld_SA2s,
    qld_SA1s = qld_SA1s,
    qld_SA1s = qld_SA1s,
    qas_locations = qas_locations,
    rsq_locations = rsq_locations_long,
    town_locations = town_locations
  )
}
