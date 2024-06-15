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

centre_renaming <- function(x) {
  case_when(
    x == "Brain Injury Rehabilitation Unit" ~ "Princess Alexandra Hospital (PAH)",
    x == "RBWH" ~ "Royal Brisbane and Women's Hospital (RBWH)",
    x == "Maleny Hospital" ~ "Maleny Soldiers Memorial Hospital",
    x == "Brighton Bain Injury Service" ~ "Brighton Brain Injury Service",
    TRUE ~ x
  )
}

remove_empty_polygons <- function(x) {
  x[!st_is_empty(x), , drop = FALSE]
}
