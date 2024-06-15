save_app_markers <- function(vis_shapes, d_centre_coords) {
  marker_cols <- c("x", "y", "popup")
  
  d_acute_centres <- d_centre_coords |> 
    as_tibble() |> 
    filter(care_type == "acute") |> 
    mutate(popup = "placeholder acute centre popup") |> 
    select(name = centre_name, all_of(marker_cols))
  
  d_rehab_centres <- d_centre_coords |> 
    as_tibble() |> 
    filter(care_type == "rehab") |> 
    mutate(popup = "placeholder rehab centre popup") |> 
    select(name = centre_name, all_of(marker_cols))
  
  d_towns <- vis_shapes$town_locations |>
    as_tibble() |> 
    mutate(popup = "town marker placeholder text") |> 
    select(name = Location, all_of(marker_cols))
  
  d_qas_locations <- vis_shapes$qas_locations |> 
    as_tibble() |> 
    mutate(popup = glue::glue("<b>Location: </b>", "{qas_location}<br>")) |> 
    select(name = qas_location, all_of(marker_cols))
  
  d_rsq_locations <- vis_shapes$rsq_locations |> 
    as_tibble() |> 
    mutate(
      type = str_to_sentence(ifelse(type == "both", "plane and helicopter", type)),
      popup = glue::glue(
        "<b>Location: </b>", "{rsq_location}<br>",
        "<b>Service: </b>", "{type}"
      )
    ) |> 
    select(name = rsq_location, all_of(marker_cols)) |> 
    distinct()
  
  
  l <- list(
    d_acute_centres = d_acute_centres,
    d_rehab_centres = d_rehab_centres,
    d_rsq_locations = d_rsq_locations,
    d_qas_locations = d_qas_locations,
    d_towns = d_towns
  )
  
  saveRDS(l, file.path(app_data_dir, "l_markers.rds"))
  
  file.path(app_data_dir, "l_markers.rds")
}