#' @export
all_base_layers <- c("Towns", "Acute centres", "Rehab centres", "Aeromedical bases", "QAS response locations")

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
data_dir <- here::here("app/data")
