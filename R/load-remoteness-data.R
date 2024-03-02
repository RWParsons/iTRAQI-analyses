get_remoteness_data <- function(remoteness_files) {
  list(
    asgs_2011_sa1 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2011_sa1")]) |>
      select(SA1_CODE2011 = sa1_maincode, ra, ra_name),
    asgs_2011_sa2 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2011_sa2")]) |>
      select(SA2_CODE2011 = sa2_maincode, ra, ra_name),
    asgs_2016_sa1 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2016_sa1")]) |>
      select(SA1_CODE2016 = sa1_maincode, ra, ra_name),
    asgs_2016_sa2 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2016_sa2")]) |>
      select(SA2_CODE2016 = sa2_maincode, ra, ra_name)
  ) |>
    lapply(\(x) mutate(x, across(contains("CODE"), as.character)))
}
