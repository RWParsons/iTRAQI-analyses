save_app_markers <- function(vis_shapes,
                             d_times,
                             get_index_function,
                             d_centre_coords) {
  marker_cols <- c("name" = "qas_location", "name" = "centre_name", "name" = "rsq_location", "x", "y", "popup")

  d_centres <- d_centre_coords |>
    as_tibble() |>
    mutate(
      care_type_text = if_else(care_type == "acute", "Acute & Rehabilitation care", "Rehabilitation care"),
      popup = glue(
        "<b>Centre name: </b>{centre_name}<br>",
        "<b>Care type: </b>{care_type_text}<br>",
        "<b>Address: </b>{address}<br>"
      )
    )

  d_acute_centres <- d_centres |>
    filter(care_type == "acute") |>
    select(any_of(marker_cols))

  d_rehab_centres <- d_centres |>
    filter(care_type == "rehab") |>
    select(any_of(marker_cols))

  d_towns <- d_times |>
    mutate(
      iTRAQI_index = get_index_function(acute_mins = acute_time, rehab_mins = rehab_time),
      acute_care_transit = ifelse(
        is.na(acute_care_transit_location),
        "",
        paste0("(via ", acute_care_transit_location, ")")
      ),
      popup = glue(
        "<b>Location: </b>{location}<br>",
        "<b>iTRAQI index: </b>{iTRAQI_index}<br>",
        "<b>Acute care destination: </b>{acute_care_centre} {acute_care_transit}<br>",
        "<b>Time to acute care (minutes): </b>{acute_time}<br>",
        "<b>Initial rehab care destination: </b>{gold_rehab_centre}<br>",
        "<b>Driving time to rehab care (minutes): </b>{round(rehab_time)}<br>"
      )
    ) |>
    select(name = location, any_of(marker_cols))

  d_qas_locations <- vis_shapes$qas_locations |>
    as_tibble() |>
    mutate(popup = glue("<b>Location: </b>", "{qas_location}<br>")) |>
    select(any_of(marker_cols))

  d_rsq_locations <- vis_shapes$rsq_locations |>
    as_tibble() |>
    mutate(
      type = str_to_sentence(ifelse(type == "both", "plane and helicopter", type)),
      popup = glue(
        "<b>Location: </b>", "{rsq_location}<br>",
        "<b>Service: </b>", "{type}"
      )
    ) |>
    select(any_of(marker_cols)) |>
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
