library(targets)
library(tarchetypes)

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
  ),

  # rehab (drive) times data
  tar_files_input(
    drive_times_files,
    files = list.files(
      "data/drive-times/",
      full.names = TRUE
    )
  ),
  tar_target(
    d_drive_times,
    read_rehab_data(drive_times_files)
  ),
  tar_target(
    qld_locations_file,
    "data/QLDLocations3422.csv",
    format = "file"
  ),
  tar_target(
    d_ids,
    get_ids(qld_locations_file)
  ),
  tar_target(
    d_island_rehab_times,
    get_island_times(d_ids)
  ),
  # get times for each "medal"
  tar_target(
    d_silver,
    get_df_times(
      d_drive_times,
      v_centres = silver_locs,
      d_islands = d_island_rehab_times
    )
  ),
  tar_target(
    d_gold,
    get_df_times(
      d_drive_times,
      v_centres = gold_locs,
      d_islands = d_island_rehab_times
    )
  ),
  tar_target(
    d_future_gold,
    get_df_times(
      d_drive_times,
      v_centres = future_gold_locs,
      d_islands = d_island_rehab_times
    )
  ),
  tar_target(
    d_platinum,
    get_df_times(
      d_drive_times,
      v_centres = platinum_locs,
      d_islands = d_island_rehab_times
    )
  ),
  tar_target(
    d_future_gold_and_cairns,
    get_df_times(
      d_drive_times,
      v_centres = future_gold_and_cairns_locs,
      d_islands = d_island_rehab_times
    )
  )
)
