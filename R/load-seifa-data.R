get_seifa_data <- function(seifa_files) {
  # SEIFA 2016 source: https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012016?OpenDocument
  # SEIFA 2011 source: https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012011?OpenDocument

  seifa_2016_sa1 <- readxl::read_xls(
    seifa_files[str_detect(basename(seifa_files), "2016_sa1")],
    sheet = "Table 3",
    skip = 6,
    col_names = FALSE
  ) |>
    (\(x) x[, c(2, (ncol(x) - 3):ncol(x))])() |>
    rename("SA1_CODE2016" = 1, "state" = 2, "rank" = 3, "decile" = 4, "percentile" = 5) |>
    mutate(quintile = quintile_from_decile(decile))

  seifa_2016_sa2 <- readxl::read_xls(
    seifa_files[str_detect(basename(seifa_files), "2016_sa2")],
    sheet = "Table 3",
    skip = 6,
    col_names = FALSE
  ) |>
    (\(x) x[, c(1, (ncol(x) - 6):(ncol(x) - 3))])() |>
    rename("SA2_CODE2016" = 1, "state" = 2, "rank" = 3, "decile" = 4, "percentile" = 5) |>
    mutate(quintile = quintile_from_decile(decile))


  sa1_digits <- readxl::read_xls(
    seifa_files[str_detect(basename(seifa_files), "2011_sa1")],
    sheet = "Table 7",
    skip = 6,
    col_names = FALSE
  ) |>
    select(code7 = 1, SA1_CODE2011 = 2)


  seifa_2011_sa1 <- readxl::read_xls(
    seifa_files[str_detect(basename(seifa_files), "2011_sa1")],
    sheet = "Table 3",
    skip = 6,
    col_names = FALSE
  ) |>
    (\(x) x[, c(1, (ncol(x) - 3):ncol(x))])() |>
    rename("code7" = 1, "state" = 2, "rank" = 3, "decile" = 4, "percentile" = 5) |>
    inner_join(sa1_digits, seifa_2011_sa1, by = "code7") |>
    select(-code7) |>
    mutate(quintile = quintile_from_decile(decile)) |>
    select(contains("CODE"), any_of(names(seifa_2016_sa2)))


  seifa_2011_sa2 <- readxl::read_xls(
    seifa_files[str_detect(basename(seifa_files), "2011_sa2")],
    sheet = "Table 3",
    skip = 6,
    col_names = FALSE
  ) |>
    (\(x) x[, c(1, (ncol(x) - 6):(ncol(x) - 3))])() |>
    rename("SA2_CODE2011" = 1, "state" = 2, "rank" = 3, "decile" = 4, "percentile" = 5) |>
    mutate(across(all_of(c("decile", "percentile")), as.numeric)) |>
    mutate(quintile = quintile_from_decile(decile))
  
  seifa_2021_sa1 <- readxl::read_xlsx(
    seifa_files[str_detect(basename(seifa_files), "2021_sa1")],
    sheet = "Table 3",
    skip = 5
  ) |> 
    select(SA1_CODE2021 = 1, state = 9, decile = 6, percentile = 7) |> 
    mutate(across(all_of(c("decile", "percentile")), as.numeric)) |>
    mutate(quintile = quintile_from_decile(decile))
  
  seifa_2021_sa2 <- readxl::read_xlsx(
    seifa_files[str_detect(basename(seifa_files), "2021_sa2")],
    sheet = "Table 3",
    skip = 5
  ) |> 
    select(SA2_CODE2021 = 1, state = 10, decile = 7, percentile = 8) |> 
    mutate(across(all_of(c("decile", "percentile")), as.numeric)) |>
    mutate(quintile = quintile_from_decile(decile))
  

  list(
    seifa_2021_sa1 = seifa_2021_sa1,
    seifa_2021_sa2 = seifa_2021_sa2,
    seifa_2016_sa1 = seifa_2016_sa1,
    seifa_2016_sa2 = seifa_2016_sa2,
    seifa_2011_sa1 = seifa_2011_sa1,
    seifa_2011_sa2 = seifa_2011_sa2
  ) |>
    lapply(\(x) mutate(x, across(contains("CODE"), as.character)))
}

quintile_from_decile <- function(x) (x + x %% 2) / 2
