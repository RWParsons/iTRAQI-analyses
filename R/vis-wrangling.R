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



  rehab_service_cats <-
    list(
      # major
      list(centre_name = "Townsville University Hospital", type = "Major", x = 0, y = 0),
      list(centre_name = "Royal Brisbane and Women's Hospital (RBWH)", type = "Major", x = 0, y = 0),
      list(centre_name = "Princess Alexandra Hospital (PAH)", type = "Major", x = 0, y = 0),
      list(centre_name = "Gold Coast University Hospital", type = "Major", x = 0, y = 0),

      # regional
      list(centre_name = "Cairns Hospital", type = "Regional", x = 0, y = 0),
      list(centre_name = "Mount Isa Hospital", type = "Regional", x = 139.493276, y = -20.730666),
      list(centre_name = "Mackay Hospital", type = "Regional", x = 149.155504, y = -21.146710),
      list(centre_name = "Rockhampton Hospital", type = "Regional", x = 0, y = 0),
      list(centre_name = "Bundaberg Hospital", type = "Regional", x = 152.3358, y = -24.8693),
      list(centre_name = "Hervey Bay Hospital", type = "Regional", x = 152.821162, y = -25.298636),
      list(centre_name = "Sunshine Coast University Hospital", type = "Regional", x = 0, y = 0),
      list(centre_name = "Caboolture Hospital", type = "Regional", x = 152.9638, y = -27.0810),
      list(centre_name = "Redcliffe Hospital", type = "Regional", x = 0, y = 0),
      list(centre_name = "Mater Adults Hospital", type = "Regional", x = 153.0281, y = -27.4850),
      list(centre_name = "Ipswich Hospital", type = "Regional", x = 152.7593, y = -27.6193),
      list(centre_name = "Toowoomba Hospital", type = "Regional", x = 151.9468, y = -27.5701),
      list(centre_name = "Logan Hospital", type = "Regional", x = 0, y = 0)
    ) |>
    bind_rows() |>
    left_join(select(centre_coords, centre_name, x2 = x, y2 = y), by = c("centre_name")) |>
    arrange(centre_name) |>
    mutate(
      x = ifelse(!is.na(x2), x2, x),
      y = ifelse(!is.na(y2), y2, y)
    ) |>
    select(-x2, -y2)

  list(
    polygons = polygons,
    qld_boundary = qld_boundary,
    qld_SA2s = qld_SA2s,
    qld_SA1s = qld_SA1s,
    qld_SA1s = qld_SA1s,
    qas_locations = qas_locations,
    rsq_locations = rsq_locations_long,
    town_locations = town_locations,
    rehab_service_cats = rehab_service_cats
  )
}
