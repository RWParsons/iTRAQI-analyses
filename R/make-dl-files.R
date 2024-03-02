make_download_file <- function(year,
                               asgs,
                               d_acute,
                               d_rehab,
                               d_remoteness,
                               d_seifa,
                               front_page_dir = dl_file_frontpages_dir) {
  # make output path
  if (!dir.exists(file.path(output_dir, "download-data"))) {
    dir.create(file.path(output_dir, "download-data"))
  }

  front_page_path <- str_subset(
    list.files(front_page_dir, full.names = TRUE),
    glue("ASGS {year} {asgs}")
  )
  download_data_file <- file.path(
    output_dir,
    "download-data",
    str_replace(basename(front_page_path), "front page ", "")
  )

  file.copy(
    from = front_page_path,
    to = download_data_file,
    overwrite = TRUE
  )

  travel_time <- get_travel_time_sheet_data(d_acute, d_rehab)

  browser()
  xlsx::write.xlsx2(
    x = as.data.frame(travel_time),
    file = download_data_file,
    sheetName = "Travel time",
    row.names = FALSE,
    append = TRUE
  )

  if (!missing(d_seifa)) {
    gc()
    d_seifa <- left_join(select(travel_time, 1), d_seifa)
    xlsx::write.xlsx2(
      x = as.data.frame(d_seifa),
      file = download_data_file,
      sheetName = "SEIFA",
      row.names = FALSE,
      append = TRUE
    )
  }
  # browser()
  if (!missing(d_remoteness)) {
    gc()
    d_remoteness <- left_join(select(travel_time, 1), d_remoteness)
    xlsx::write.xlsx2(
      x = as.data.frame(d_remoteness),
      file = download_data_file,
      sheetName = "Remoteness",
      row.names = FALSE,
      append = TRUE
    )
  }

  download_data_file
}


get_travel_time_sheet_data <- function(d_acute, d_rehab) {
  d_combined_times <- inner_join(
    rename_travel_time_df(d_acute, "acute"),
    rename_travel_time_df(d_rehab, "rehab")
  )

  d_combined_times$iTRAQI_index <- get_iTRAQI_index(
    acute_mins = d_combined_times$median_time_to_acute_care,
    rehab_mins = d_combined_times$median_time_to_rehab_care
  )
  d_combined_times
}

rename_travel_time_df <- function(data, type) {
  stopifnot(type %in% c("acute", "rehab"))
  if (type == "acute") {
    names(data)[-1] <- get_new_tt_names("acute")
  } else {
    names(data)[-1] <- get_new_tt_names("rehab")
  }
  data
}

get_new_tt_names <- function(x) {
  c(
    glue("median_time_to_{x}_care"),
    glue("min_time_to_{x}_care"),
    glue("max_time_to_{x}_care")
  )
}

get_iTRAQI_index <- function(acute_mins, rehab_mins) {
  acute_cat <- cut(acute_mins / 60, breaks = c(-Inf, 1, 2, 4, 6, Inf))
  rehab_cat <- cut(rehab_mins / 60, breaks = c(-Inf, 1, 2, 4, 6, Inf))

  acute_label <- as.numeric(acute_cat)
  rehab_label <- LETTERS[rehab_cat]

  paste0(acute_label, rehab_label)
}
