save_app_scale_fxs <- function(itraqi_list) {
  fx_list <- list(
    seifa_scale_to_text = seifa_scale_to_text,
    seifa_text_to_value = seifa_text_to_value,
    ra_scale_to_text = ra_scale_to_text,
    ra_text_to_value = ra_text_to_value,
    itraqi_index = itraqi_list$iTRAQI_index
  )
  
  saveRDS(fx_list, file.path(app_data_dir, "scale_fxs.rds"))
  file.path(app_data_dir, "scale_fxs.rds")
}


seifa_text_to_value <- function(x) {
  case_when(
    x == "Most disadvantaged" ~ 1,
    x == "Disadvantaged" ~ 2,
    x == "Middle socio-economic status" ~ 3,
    x == "Advantaged" ~ 4,
    x == "Most advantaged" ~ 5,
  )
}

ra_scale_to_text <- function(x) {
  case_when(
    x == 0 ~ "Major Cities of Australia",
    x == 1 ~ "Inner Regional Australia",
    x == 2 ~ "Outer Regional Australia",
    x == 3 ~ "Remote Australia",
    x == 4 ~ "Very Remote Australia",
    TRUE ~ "NA"
  )
}

ra_text_to_value <- function(x) {
  case_when(
    x == "Major Cities of Australia" ~ 0,
    x == "Inner Regional Australia" ~ 1,
    x == "Outer Regional Australia" ~ 2,
    x == "Remote Australia" ~ 3,
    x == "Very Remote Australia" ~ 4,
  )
}