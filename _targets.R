library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tidyverse", "sf"), # packages that your targets need to run
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
  ),
  tar_target(
    l_all_drive_times,
    list(
      d_silver = d_silver,
      d_gold = d_gold,
      d_future_gold = d_future_gold,
      d_platinum = d_platinum,
      d_future_gold_and_cairns = d_future_gold_and_cairns
    )
  ),
  tar_target(
    l_travel_times,
    get_travel_times(d_acute, d_drive_times, d_island_rehab_times, l_all_drive_times)
  ),
  tar_target(
    d_input_shapes,
    get_input_shapes(agg_grid_cellsize = 0.1, raster_grid_cellsize = 0.3)
  ),

  # acute
  tar_target(
    d_acute_kriged_raster,
    do_kriging_model(
      points = d_input_shapes$qld_pt_raster_grid,
      data = l_travel_times$d_times,
      formula = acute_time ~ 1,
      grid_crs = d_input_shapes$grid_crs,
      get_raster = TRUE
    )
  ),
  tar_target(
    d_acute_kriged_for_agg,
    do_kriging_model(
      points = d_input_shapes$qld_pt_agg_grid,
      data = l_travel_times$d_times,
      formula = acute_time ~ 1,
      grid_crs = d_input_shapes$grid_crs,
      get_raster = FALSE
    )
  ),

  # rehab
  tar_target(
    d_rehab_kriged_raster,
    do_kriging_model(
      points = d_input_shapes$qld_pt_raster_grid,
      data = l_travel_times$d_times,
      formula = rehab_time ~ 1,
      grid_crs = d_input_shapes$grid_crs,
      get_raster = TRUE
    )
  ),
  tar_target(
    d_rehab_kriged_for_agg,
    do_kriging_model(
      points = d_input_shapes$qld_pt_agg_grid,
      data = l_travel_times$d_times,
      formula = rehab_time ~ 1,
      grid_crs = d_input_shapes$grid_crs,
      get_raster = FALSE
    )
  ),

  # load and wrangle SEIFA data
  tar_files_input(
    seifa_files,
    files = list.files(
      "data/remoteness_and_seifa_data/",
      pattern = "*.xls",
      full.names = TRUE
    )
  ),
  tar_target(
    l_seifa_dlist,
    get_seifa_data(seifa_files)
  ),

  # load and wrangle remoteness data
  tar_files_input(
    remoteness_files,
    files = list.files(
      "data/remoteness_and_seifa_data/",
      pattern = "*.dta",
      full.names = TRUE
    )
  ),
  tar_target(
    l_remoteness_dlist,
    get_remoteness_data(remoteness_files)
  )
)
