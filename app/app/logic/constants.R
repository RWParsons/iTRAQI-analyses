box::use(
  here,
)

#' @export
all_base_layers <- c(
  "Towns",
  "Acute centres",
  "Rehab centres",
  "Aeromedical locations",
  "QAS response locations"
)

#' @export
default_base_layers <- c("Towns", "Acute centres", "Rehab centres")

#' @export
layer_choices <- c(
  None = "none",
  `SA1 Index` = "sa1_index",
  `SA2 Index` = "sa2_index",
  `Acute time` = "acute_time",
  `SA1 Acute` = "sa1_acute",
  `SA2 Acute` = "sa2_acute",
  `Rehab time` = "rehab_time",
  `SA1 Rehab` = "sa1_rehab",
  `SA2 Rehab` = "sa2_rehab"
)

#' @export
data_dir <- here$here("app/data")

#' @export
downloads_dir <- file.path(data_dir, "download-data")

#' @export
on_map_citation <- "iTRAQI: injury Treatment & Rehabilitation Accessibility Queensland Index, 2024, Version 2.0."
