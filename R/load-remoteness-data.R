get_remoteness_data <- function(remoteness_files) {
  d_list <- list(
    asgs_2011_sa1 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2011_sa1")]) |>
      select(SA1_CODE2011 = sa1_maincode, ra, ra_name),
    asgs_2011_sa2 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2011_sa2")]) |>
      select(SA2_CODE2011 = sa2_maincode, ra, ra_name),
    asgs_2016_sa1 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2016_sa1")]) |>
      select(SA1_CODE2016 = sa1_maincode, ra, ra_name),
    asgs_2016_sa2 = haven::read_dta(remoteness_files[str_detect(basename(remoteness_files), "2016_sa2")]) |>
      select(SA2_CODE2016 = sa2_maincode, ra, ra_name)
  ) 
  
  ra_lkp <- distinct(d_list$asgs_2011_sa1, ra, ra_name)
  # add some placeholder RA data while Susanna preps the SA2 input data
  qld_ra_sa1s <- strayr::read_absmap("sa12021") |> 
    remove_empty_polygons() |> 
    filter(state_name_2021 == "Queensland") |> 
    as_tibble() |> 
    rowwise() |> 
    mutate(ra = sample(0:4, size = 1)) |> 
    ungroup() |> 
    left_join(ra_lkp, by = "ra") |> 
    select(SA1_CODE2021 = sa1_code_2021, ra, ra_name)
  
  qld_ra_sa2s <- strayr::read_absmap("sa22021") |> 
    remove_empty_polygons() |> 
    filter(state_name_2021 == "Queensland") |> 
    as_tibble() |> 
    rowwise() |> 
    mutate(ra = sample(0:4, size = 1)) |> 
    ungroup() |> 
    left_join(ra_lkp, by = "ra") |> 
    select(SA2_CODE2021 = sa2_code_2021, ra, ra_name)
  
  
  d_list |> 
    c(list(asgs_2021_sa1 = qld_ra_sa1s, asgs_2021_sa2 = qld_ra_sa2s)) |>
    lapply(\(x) mutate(x, across(contains("CODE"), as.character)))
}
