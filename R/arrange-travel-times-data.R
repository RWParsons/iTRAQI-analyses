get_travel_times <- function(d_acute,
                             d_drive_times,
                             d_island_rehab_times,
                             l_all_drive_times) {
  acute_drive_times <- d_acute |>
    mutate(acute_care_centre = ifelse(acute_care_centre == "Brisbane (PAH/RBWH)",
      "Brain Injury Rehabilitation Unit",
      acute_care_centre
    )) |>
    select(-acute_time, -acute_care_transit_location) |>
    inner_join(d_drive_times, by = c("town_name", "acute_care_centre" = "centre"))


  df_island_acute_drive_times <- acute_drive_times |>
    filter(town_name %in% d_island_rehab_times$closest_town) |>
    rename(mainland_to_acute_centre = minutes) |>
    select(-id, -x, -y) |>
    (\(x) left_join(d_island_rehab_times, x, by = c("closest_town" = "town_name")))() |>
    mutate(minutes = mainland_to_acute_centre + travel_time) |>
    rename(town_name = island_location) |>
    select(names(acute_drive_times))

  acute_drive_times_all <- rbind(acute_drive_times, df_island_acute_drive_times)

  weighted_rehab_times <- l_all_drive_times$d_future_gold |>
    rename(silver_rehab_centre = centre, silver_time = minutes) |>
    inner_join(
      select(acute_drive_times_all, id, gold_rehab_centre = acute_care_centre, gold_time = minutes),
      by = "id"
    ) |>
    mutate(minutes = (silver_time + gold_time) / 2) |>
    select(-silver_time, -gold_time)

  all_rehab_times <-
    rename(l_all_drive_times$d_silver, silver_rehab_centre = centre, silver_time = minutes) |>
    inner_join(
      select(l_all_drive_times$d_gold, id, gold_rehab_centre = centre, gold_time = minutes),
      by = "id"
    ) |>
    inner_join(
      select(l_all_drive_times$d_future_gold, id, future_gold_rehab_centre = centre, future_gold_time = minutes),
      by = "id"
    ) |>
    inner_join(
      select(l_all_drive_times$d_platinum, id, platinum_rehab_centre = centre, platinum_time = minutes),
      by = "id"
    ) |>
    inner_join(
      select(l_all_drive_times$d_future_gold_and_cairns, id, future_gold_and_cairns_rehab_centre = centre, future_gold_and_cairns_time = minutes),
      by = "id"
    )

  list(
    d_all_rehab_times = all_rehab_times,
    d_weighted_rehab_times = weighted_rehab_times
  )
}
