read_rehab_data <- function(files) {
  plyr::ldply(files, read.csv) |>
    select(
      id = From_ID,
      town_name = From_Location,
      x = From_x,
      y = From_y,
      centre = To_Title,
      minutes = Total_Minutes
    ) |>
    mutate(centre = str_trim(centre)) |>
    as_tibble()
}


get_ids <- function(ids_file) {
  read.csv(ids_file)
}

get_df_times <- function(d_drive_times, v_centres, d_islands) {
  df_times <-
    d_drive_times |>
    filter(centre %in% v_centres) |>
    group_by(id) |>
    arrange(minutes) |>
    slice(1) |>
    ungroup()

  islands_times <-
    left_join(
      d_islands,
      select(df_times, -x, -y, -id),
      by = c("closest_town" = "town_name")
    ) |>
    mutate(minutes = minutes + travel_time) |>
    rename(town_name = island_location) |>
    select(names(df_times))

  df_times <- bind_rows(df_times, islands_times)
  df_times$centre <- centre_renaming(df_times$centre)

  df_times
}

get_island_times <- function(d_ids) {
  island_list <- list(
    list(
      island_location = "Boigu Island",
      closest_town = "Seisia",
      travel_time = (200 / 30) * 60 # 200kms @ 30km/hr
    ),
    list(
      island_location = "Saibai Island",
      closest_town = "Seisia",
      travel_time = (165 / 30) * 60
    ),
    list(
      island_location = "Erub (Darnley) Island",
      closest_town = "Seisia",
      travel_time = (210 / 30) * 60
    ),
    list(
      island_location = "Yorke Island",
      closest_town = "Seisia",
      travel_time = (170 / 30) * 60
    ),
    list(
      island_location = "Iama (Yam) Island",
      closest_town = "Seisia",
      travel_time = (115 / 30) * 60
    ),
    list(
      island_location = "Mer (Murray) Island",
      closest_town = "Seisia",
      travel_time = (215 / 30) * 60
    ),
    list(
      island_location = "Mabuiag Island",
      closest_town = "Seisia",
      travel_time = (105 / 30) * 60
    ),
    list(
      island_location = "Badu Island",
      closest_town = "Seisia",
      travel_time = (80 / 30) * 60
    ),
    list(
      island_location = "St Pauls", # called moa island on google maps
      closest_town = "Seisia",
      travel_time = (75 / 30) * 60
    ),
    list(
      island_location = "Warraber Island",
      closest_town = "Seisia",
      travel_time = (85 / 30) * 60
    ),
    list(
      island_location = "Hammond Island",
      closest_town = "Seisia",
      travel_time = (35 / 30) * 60
    ),
    list(
      island_location = "Gununa",
      closest_town = "Doomadgee",
      travel_time = (35 / 30) * 60 + 94 # 35min boat (assume same speed as torres strait) to Gangalidda, then 94 min drive to Doomadgee
    ),
    list(
      island_location = "Hamilton Island",
      closest_town = "Airlie Beach",
      travel_time = 35 + 15 # 35 min ferry + 15 min drive (https://www.directferries.com.au/shute_harbour_hamilton_island_marina_ferry.htm)
    )
  )

  do.call(rbind, island_list) |>
    as.data.frame() |>
    mutate(across(everything(), unlist)) |>
    left_join(rename(d_ids, id = ID), by = c("island_location" = "Location"))
}
