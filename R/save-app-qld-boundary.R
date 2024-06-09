save_qld_boundary <- function(state_boundary) {
  state_boundary_simplified <- rmapshaper::ms_simplify(state_boundary, keep = 0.03)
  
  saveRDS(state_boundary_simplified, file.path(output_dir, "state_boundary.rds"))
  file.path(output_dir, "state_boundary.rds")
}