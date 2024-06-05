box::use(
  here,
)

analyses_output_dir <- here$here("../output")

app_data_dir <- here$here("app/data")

outputs_to_move <- c(
  "stacked_SA1_and_SA2_polygons_geom.rds",
  "stacked_SA1_and_SA2_linestrings_geom.rds",
  "stacked_sa1_sa2_data.rds",
  "palette_list.rds",
  "scale_fxs.rds"
)

x <- purrr::map(
  outputs_to_move,
  \(fname) {
    # browser()
    # analyses_outfile <- readRDS(file.path(analyses_output_dir, fname))
    analyses_outfile_hash <- rlang::hash_file(file.path(analyses_output_dir, fname))
    if (fname %in% list.files(app_data_dir)) {
      app_file_hash <- rlang::hash_file(file.path(app_data_dir, fname))

      move_file <- analyses_outfile_hash != app_file_hash
    } else {
      move_file <- TRUE
    }

    if (move_file) {
      cli::cli({
        cli::cli_h2(glue::glue("loading file: {fname}"))
      })
      file.copy(
        from = file.path(analyses_output_dir, fname),
        to = file.path(app_data_dir, fname)
      )
    }
  }
)
