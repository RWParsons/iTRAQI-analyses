library(targets)

# Set target options:
tar_option_set(
  packages = c("tidyverse"), # packages that your targets need to run
  format = "rds", # Optionally set the default storage format. qs is fast.
  controller = crew::crew_controller_local(workers = 4)
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multiprocess")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  # acute times data
  tar_target(
    acute_times_file,
    "data/Qld_towns_RSQ pathways.xlsx",
    format = "file"
  ),
  tar_target(
    d_acute,
    read_acute_pathways(acute_times_file)
  )
)
