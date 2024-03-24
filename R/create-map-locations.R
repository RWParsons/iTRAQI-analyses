create_app_locs_and_times <- function(travel_times) {
  path <- file.path(output_dir, "QLD_locations_with_RSQ_times.csv")
  write.csv(travel_times$d_times, file = path, row.names = FALSE)
  path
}
