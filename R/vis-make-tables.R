make_itraqi_counts_tbls <- function(iTRAQI_list) {
  d_itraqi <- bind_rows(
    iTRAQI_list$qld_SA1s,
    iTRAQI_list$qld_SA2s
  ) |>
    as_tibble()

  output_dir <- file.path(output_dir, "tables")

  # make table for counts by ASGS level
  itraqi_counts_by_sa_level <- d_itraqi |>
    group_by(index, SA_level) |>
    summarize(n = n()) |>
    ungroup() |>
    pivot_wider(names_from = SA_level, values_from = n, names_prefix = "SA") |>
    janitor::adorn_totals("row")

  cnts_by_sa_file_path <- file.path(output_dir, "counts_by_sa_level.csv")
  write.csv(itraqi_counts_by_sa_level, file = cnts_by_sa_file_path, row.names = FALSE)

  # make table for ocunts by remoteness
  remoteness_labels <- c("Major Cities", "Inner Regional", "Outer Regional", "Remote", "Very Remote")
  d_remoteness_labels <- tibble(
    ra = 0:4,
    remoteness = factor(remoteness_labels, levels = remoteness_labels)
  )

  itraqi_counts_by_remoteness <- iTRAQI_list$qld_SA1s |>
    as_tibble() |>
    left_join(d_remoteness_labels, by = "ra") |>
    group_by(index, remoteness) |>
    summarize(n = n()) |>
    ungroup() |>
    pivot_wider(names_from = remoteness, values_from = n) |>
    mutate(across(!index, format_numeric_col))

  cnts_by_ra_file_path <- file.path(output_dir, "sa1_counts_by_remoteness_level.csv")
  write.csv(itraqi_counts_by_remoteness, file = cnts_by_ra_file_path, row.names = FALSE)

  # make table for ocunts by SEIFA
  seifa_labels <- c("Most Disadvantaged", "Disadvantaged", "Middle SES", "Advantaged", "Most Advantaged")
  d_seifa_labels <- tibble(
    seifa_quintile = 1:5,
    seifa = factor(seifa_labels, levels = seifa_labels)
  )

  itraqi_counts_by_seifa <- iTRAQI_list$qld_SA1s |>
    as_tibble() |>
    left_join(d_seifa_labels, by = "seifa_quintile") |>
    group_by(index, seifa) |>
    summarize(n = n()) |>
    ungroup() |>
    pivot_wider(names_from = seifa, values_from = n) |>
    mutate(across(!index, format_numeric_col))

  cnts_by_seifa_file_path <- file.path(output_dir, "sa1_counts_by_seifa_level.csv")
  write.csv(itraqi_counts_by_seifa, file = cnts_by_seifa_file_path, row.names = FALSE)

  list(
    itraqi_counts_by_sa_level = itraqi_counts_by_sa_level,
    itraqi_counts_by_remoteness = itraqi_counts_by_remoteness,
    itraqi_counts_by_seifa = itraqi_counts_by_seifa
  )
}


format_numeric_col <- function(x, ...) {
  x <- scales::label_comma(...)(x)
  replace_na(x, "")
}

make_palette_table <- function(iTRAQI_list) {
  acute_labels <- breaks_to_labels(iTRAQI_list$iTRAQI_acute_breaks)
  rehab_labels <- breaks_to_labels(iTRAQI_list$iTRAQI_rehab_breaks)

  output_dir <- file.path(output_dir, "tables")

  dat <- tibble(
    index = iTRAQI_list$iTRAQI_bins,
    index_col = iTRAQI_list$paliTRAQI(iTRAQI_list$iTRAQI_bins)
  ) |>
    arrange(index) |>
    rowwise() |>
    mutate(
      # acute = number
      # rehab = letter
      acute_lev = as.integer(str_extract(index, "[1-9]")),
      rehab_lev = which(LETTERS == str_extract(index, "[A-Z]"))
    ) |>
    ungroup() |>
    (\(d) {
      # add labels for timeframes
      d$`Acute Care timeframe` <- acute_labels[d$acute_lev]
      d$`Rehab Care timeframe` <- rehab_labels[d$rehab_lev]

      # add gg column as a block of the colour used in maps
      d$`Colour` <- lapply(d$index_col, gg)
      d
    })() |>
    rename("iTRAQI Category" = index) |>
    select(-index_col, -acute_lev, -rehab_lev)

  ft <- flextable(dat) |>
    compose(
      j = c("Colour"),
      value = as_paragraph(gg_chunk(value = ., height = .15, width = 1)),
      use_dot = TRUE
    )

  ft_out_path <- file.path(output_dir, "iTRAQI-palette.docx")
  save_as_docx(ft, path = ft_out_path)

  ft_out_path
}

breaks_to_labels <- function(x) {
  cut(1, breaks = x) |>
    levels() |>
    str_split(",") |>
    map(~ str_extract(.x, "[0-9]+")) |>
    map(\(.x) {
      if (is.na(.x[1])) {
        c <- paste0("<", .x[2])
      } else if (is.na(.x[2])) {
        c <- paste0(">", .x[1])
      } else {
        c <- paste0(.x[1], " – ", .x[2])
      }
      c
    }) |>
    unlist()
}


gg <- function(hex) {
  tibble(
    x = 1,
    y = 1,
    z = 1
  ) |>
    ggplot(aes(x, y)) +
    geom_tile(fill = hex) +
    theme_void()
}
