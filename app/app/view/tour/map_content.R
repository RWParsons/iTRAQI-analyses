#' @export
get_map_layers <- function(tab) {
  map_layers[[tab]]
}

map_layers <- list(
  t1 = c(),
  t2 = c("aria"),
  t3 = c("towns", "rsq", "qas"),
  t4 = c("acute_centres"),
  t5 = c("rehab_centres"),
  t6 = c("acute_centres", "towns"),
  t7 = c("acute_centres", "towns", "acute_time"),
  t8 = c("rehab_centres", "towns", "rehab_time"),
  t9 = c("towns", "sa1_index"),
  t10 = c()
)
