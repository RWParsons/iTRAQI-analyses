read_acute_pathways <- function(file) {
  df_acute_addons <- data.frame(
    # add brisbane as 8 minutes for acute care
    # add rbwh as 0 minutes
    town_name = c("Brisbane", "RBWH"),
    acute_time = c(8, 0),
    acute_care_transit_location = rep("Brisbane (PAH/RBWH)", 2),
    acute_care_centre = rep("Brisbane (PAH/RBWH)", 2)
  )

  readxl::read_excel(file, skip = 2) |>
    select(
      town_name = TOWN_NAME, acute_time = Total_transport_time_min,
      acute_care_transit_location = Destination1, acute_care_centre = Destination2
    ) |>
    filter(!is.na(acute_care_centre)) |>
    mutate(
      acute_care_centre = clean_acute_centre(acute_care_centre),
      acute_care_transit_location = clean_acute_centre(acute_care_transit_location)
    ) |>
    rbind(df_acute_addons) |>
    distinct()
}


clean_acute_centre <- function(x) {
  x <- tolower(x)
  brisbane_centres <- c(
    "pah",
    "princess alexandra hospital",
    "rbwh",
    "royal brisbane and women's hospital"
  )
  case_when(
    x %in% brisbane_centres ~ "Brisbane (PAH/RBWH)",
    x %in% c("gcuh", "gold coast university hospital") ~ "Gold Coast University Hospital",
    x == "townsville hospital" ~ "Townsville University Hospital",
    x == "rockhampton" ~ "Rockhampton Hospital",
    x == "camooweal primary health clinic" ~ "Camooweal Primary Health Centre",
    x == "taroom" ~ "Taroom Hospital",
    x == "mareeba" ~ "Mareeba Hospital",
    x == "weipa" ~ "Weipa Hospital",
    x == "bamaga" ~ "Bamaga Hospital",
    x == "thurday island" ~ "Thursday Island Hospital",
    TRUE ~ str_replace(str_to_title(x), "Phc", "Primary Health Centre")
  )
}
