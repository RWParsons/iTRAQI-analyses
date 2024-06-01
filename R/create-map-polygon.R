create_app_polygons <- function(data, asgs_year, simplify_keep) {
  names(data$sa2_seifa)[1] <- "SA2_CODE"
  names(data$sa1_seifa)[1] <- "SA1_CODE"

  names(data$sa2_ra)[1] <- "SA2_CODE"
  names(data$sa1_ra)[1] <- "SA1_CODE"

  names(data$sa2_rehab)[1] <- "SA2_CODE"
  names(data$sa1_rehab)[1] <- "SA1_CODE"

  names(data$sa2_acute)[1] <- "SA2_CODE"
  names(data$sa1_acute)[1] <- "SA1_CODE"

  data$sa1_seifa <- data$sa1_seifa |>
    mutate(SA1_CODE = as.character(SA1_CODE))

  data$sa2_seifa <- data$sa2_seifa |>
    mutate(SA2_CODE = as.character(SA2_CODE))

  data$sa1_ra <- data$sa1_ra |>
    mutate(SA1_CODE = as.character(SA1_CODE))

  data$sa2_ra <- data$sa2_ra |>
    mutate(SA2_CODE = as.character(SA2_CODE))


  sa1_poly <- strayr::read_absmap(glue("sa1{asgs_year}")) |>
    (\(d) {
      names(d)[1] <- "SA1_CODE"
      names(d)[str_detect(names(d), "sa2_name_")] <- "SA2_NAME"
      names(d)[str_detect(names(d), "state_name_")] <- "STATE_NAME"
      d
    })() |>
    filter(STATE_NAME == "Queensland") |>
    rmapshaper::ms_simplify(keep = simplify_keep) |>
    select(all_of(c("SA1_CODE", "SA2_NAME"))) |>
    mutate(SA_level = 1) |>
    left_join(select(data$sa1_seifa, 1, seifa_quintile = quintile)) |>
    left_join(select(data$sa1_ra, 1, ra_name, ra))

  sa1_rehab <- sa1_poly |>
    as_tibble() |>
    left_join(data$sa1_rehab) |>
    mutate(
      popup_rehab = glue(get_popup_glue("SA1", "rehab"))
    ) |>
    select(SA1_CODE, value_rehab = value, popup_rehab)

  sa1_acute <- sa1_poly |>
    as_tibble() |>
    left_join(data$sa1_acute) |>
    mutate(
      popup_acute = glue(get_popup_glue("SA1", "acute"))
    ) |>
    select(SA1_CODE, value_acute = value, popup_acute)


  sa2_poly <- strayr::read_absmap(glue("sa2{asgs_year}")) |>
    (\(d) {
      names(d)[1] <- "SA2_CODE"
      names(d)[str_detect(names(d), "sa2_name_")] <- "SA2_NAME"
      names(d)[str_detect(names(d), "state_name_")] <- "STATE_NAME"
      d
    })() |>
    filter(STATE_NAME == "Queensland") |>
    rmapshaper::ms_simplify(keep = simplify_keep) |>
    select(all_of(c("SA2_CODE", "SA2_NAME"))) |>
    mutate(SA_level = 2) |>
    left_join(select(data$sa2_seifa, 1, seifa_quintile = quintile)) |>
    left_join(select(data$sa2_ra, 1, ra_name, ra))


  sa2_rehab <- sa2_poly |>
    as_tibble() |>
    left_join(data$sa2_rehab) |>
    mutate(
      popup_rehab = glue(get_popup_glue("SA2", "rehab"))
    ) |>
    select(SA2_CODE, value_rehab = value, popup_rehab)

  sa2_acute <- sa2_poly |>
    as_tibble() |>
    left_join(data$sa2_acute) |>
    mutate(
      popup_acute = glue(get_popup_glue("SA2", "acute"))
    ) |>
    select(SA2_CODE, value_acute = value, popup_acute)


  cols <- c(
    "CODE",
    "ra",
    "seifa_quintile",
    "popup_acute",
    "value_acute",
    "popup_rehab",
    "value_rehab",
    "SA_level"
  )
  
  sa2_all <- sa2_poly |>
    left_join(sa2_rehab) |>
    left_join(sa2_acute) |>
    rename(CODE = SA2_CODE) |>
    select(all_of(cols))

  sa1_all <- sa1_poly |>
    left_join(sa1_rehab) |>
    left_join(sa1_acute) |>
    rename(CODE = SA1_CODE) |>
    select(all_of(cols))
  
  sa2_polygon <- sa2_all |>
    select(CODE) |>
    st_cast("MULTIPOLYGON") |>
    st_cast("POLYGON")
  
  sa2_linestring <- sa2_polygon |> 
    st_cast("LINESTRING") |> 
    group_by(CODE) |> 
    mutate(layerid = glue("{CODE}-linestring-{row_number()}")) |> 
    ungroup()
  
  sa1_polygon <- sa1_all |> 
    select(CODE) |> 
    st_cast("MULTIPOLYGON") |> 
    st_cast("POLYGON") |> 
    group_by(CODE) |> 
    mutate(layerid = glue("{CODE}-polygon-{row_number()}")) |> 
    ungroup()
  
  
  sa1_linestring <- sa1_polygon |> 
    st_cast("LINESTRING") |> 
    group_by(CODE) |> 
    mutate(layerid = glue("{CODE}-linestring-{row_number()}")) |> 
    ungroup()
  
  sa1_sa2_code_lkp <- strayr::read_absmap(glue("sa1{asgs_year}")) |>
    filter(sa1_code_2016 %in% sa1_all$CODE) |> 
    as_tibble() |>
    select(starts_with("sa1_code"), starts_with("sa2_code")) |> 
    rename(sa1_code = 1, sa2_code = 2)
  
  stacked_sa1_sa2_polygons <- rbind(sa1_all, sa2_all)
  
  stacked_sa1_sa2_data <- stacked_sa1_sa2_polygons |> 
    as_tibble() |> 
    select(-geometry)
  
  linestring_layerid_lkp <- bind_rows(sa1_linestring, sa2_linestring) |>
    as_tibble() |>
    select(-geometry) |>
    mutate(type = "linestring")
  
  sa1_polygon_lkp <- sa1_polygon |>
    as_tibble() |>
    select(-geometry)
  
  polygon_layerid_lkp <- sa1_sa2_code_lkp |>
    inner_join(sa1_polygon_lkp, by = c("sa1_code" = "CODE")) |>
    pivot_longer(!layerid, values_to = "CODE") |>
    select(-name) |>
    mutate(type = "polygon")
  
  sa_code_layerid_lkp <- bind_rows(linestring_layerid_lkp, polygon_layerid_lkp)
  
  # saveRDS(sa2_polygon, file.path(output_dir, "sa2_polygon.rds"))
  saveRDS(sa2_linestring, file.path(output_dir, "sa2_linestring.rds"))
  saveRDS(sa1_polygon, file.path(output_dir, "sa1_polygon.rds"))
  saveRDS(sa1_linestring, file.path(output_dir, "sa1_linestring.rds"))
  saveRDS(sa2_all, file.path(output_dir, "sa2_all_polygons.rds"))
  saveRDS(sa1_all, file.path(output_dir, "sa1_all_polygons.rds"))
  saveRDS(sa1_sa2_code_lkp, file.path(output_dir, "sa1_sa2_code_lkp.rds"))
  saveRDS(stacked_sa1_sa2_data, file.path(output_dir, "stacked_sa1_sa2_data.rds"))
  saveRDS(sa_code_layerid_lkp, file.path(output_dir, "sa_code_layerid_lkp.rds"))
  
  

  saveRDS(stacked_sa1_sa2_polygons, file.path(output_dir, "stacked_SA1_and_SA2_polygons.rds"))
  file.path(output_dir, "stacked_SA1_and_SA2_polygons.rds")
}


get_popup_glue <- function(asgs, care_type) {
  glue(
    .open = "@", .close = "^",
    "<b>SA2 Region: </b> {SA2_NAME} <br>",
    "<b>@asgs^ ID: </b>{@asgs^_CODE}<br>",
    "<b>Remoteness: </b>{ra_name}<br>",
    "<b>SEIFA: </b>{seifa_scale_to_text(seifa_quintile)}<br>",
    "<b>Time to @care_type^ care in minutes (estimate [min - max]): </b><br>",
    "&nbsp;&nbsp;&nbsp;&nbsp; {round(value)} [{round(min)} - {round(max)}]<br>"
  ) |>
    as.character()
}



seifa_scale_to_text <- function(x) {
  case_when(
    x == 1 ~ "Most disadvantaged",
    x == 2 ~ "Disadvantaged",
    x == 3 ~ "Middle socio-economic status",
    x == 4 ~ "Advantaged",
    x == 5 ~ "Most advantaged",
    .default = "NA"
  )
}
