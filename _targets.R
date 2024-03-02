library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tidyverse", "sf", "glue"), # packages that your targets need to run
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
    # get_input_shapes(agg_grid_cellsize = cell_size_agg, raster_grid_cellsize = cell_size_raster)
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
  ),

  # summarise kriging model within ASGS areas

  # SA2s
  tar_target(
    d_sa2_2011_acute_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA2",
      ASGS_year = "2011"
    )
  ),
  tar_target(
    d_sa2_2011_rehab_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA2",
      ASGS_year = "2011"
    )
  ),
  tar_target(
    d_sa2_2016_acute_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA2",
      ASGS_year = "2016"
    )
  ),
  tar_target(
    d_sa2_2016_rehab_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA2",
      ASGS_year = "2016"
    )
  ),
  tar_target(
    d_sa2_2021_acute_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA2",
      ASGS_year = "2021"
    )
  ),
  tar_target(
    d_sa2_2021_rehab_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA2",
      ASGS_year = "2021"
    )
  ),

  # SA1s
  tar_target(
    d_sa1_2011_acute_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA1",
      ASGS_year = "2011"
    )
  ),
  tar_target(
    d_sa1_2011_rehab_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA1",
      ASGS_year = "2011"
    )
  ),
  tar_target(
    d_sa1_2016_acute_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA1",
      ASGS_year = "2016"
    )
  ),
  tar_target(
    d_sa1_2016_rehab_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA1",
      ASGS_year = "2016"
    )
  ),
  tar_target(
    d_sa1_2021_acute_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA1",
      ASGS_year = "2021"
    )
  ),
  tar_target(
    d_sa1_2021_rehab_time,
    aggregate_kriging_model_to_ASGS(
      kriged_spdf = d_rehab_kriged_for_agg$kriged_layer,
      ASGS_level = "SA1",
      ASGS_year = "2021"
    )
  ),
  tar_target(
    app_polygons,
    create_app_polygons(
      data = list(
        sa1_acute = d_sa1_2016_acute_time,
        sa2_acute = d_sa2_2016_acute_time,
        sa1_rehab = d_sa1_2016_rehab_time,
        sa2_rehab = d_sa2_2016_rehab_time,
        sa1_seifa = l_seifa_dlist$seifa_2016_sa1,
        sa2_seifa = l_seifa_dlist$seifa_2016_sa2,
        sa1_ra = l_remoteness_dlist$asgs_2016_sa1,
        sa2_ra = l_remoteness_dlist$asgs_2016_sa2
      ),
      asgs_year = 2016,
      simplify_keep = 0.1
    ),
    format = "file"
  ),

  # make download data
  ## 2011
  tar_target(
    dl_file_2011_SA1,
    make_download_file(
      year = "2011",
      asgs = "SA1",
      d_acute = d_sa1_2011_acute_time,
      d_rehab = d_sa1_2011_rehab_time,
      d_remoteness = l_remoteness_dlist$asgs_2011_sa1,
      d_seifa = l_seifa_dlist$seifa_2011_sa1
    )
  ),
  tar_target(
    dl_file_2011_SA2,
    make_download_file(
      year = "2011",
      asgs = "SA2",
      d_acute = d_sa2_2011_acute_time,
      d_rehab = d_sa2_2011_rehab_time,
      d_remoteness = l_remoteness_dlist$asgs_2011_sa2,
      d_seifa = l_seifa_dlist$seifa_2011_sa2
    )
  ),
  ## 2016
  tar_target(
    dl_file_2016_SA1,
    make_download_file(
      year = "2016",
      asgs = "SA1",
      d_acute = d_sa1_2016_acute_time,
      d_rehab = d_sa1_2016_rehab_time,
      d_remoteness = l_remoteness_dlist$asgs_2016_sa1,
      d_seifa = l_seifa_dlist$seifa_2016_sa1
    )
  ),
  tar_target(
    dl_file_2016_SA2,
    make_download_file(
      year = "2016",
      asgs = "SA2",
      d_acute = d_sa2_2016_acute_time,
      d_rehab = d_sa2_2016_rehab_time,
      d_remoteness = l_remoteness_dlist$asgs_2016_sa2,
      d_seifa = l_seifa_dlist$seifa_2016_sa2
    )
  ),
  ## 2021
  tar_target(
    dl_file_2021_SA1,
    make_download_file(
      year = "2021",
      asgs = "SA1",
      d_acute = d_sa1_2021_acute_time,
      d_rehab = d_sa1_2021_rehab_time
    )
  ),
  tar_target(
    dl_file_2021_SA2,
    make_download_file(
      year = "2021",
      asgs = "SA2",
      d_acute = d_sa2_2021_acute_time,
      d_rehab = d_sa2_2021_rehab_time
    )
  )
)
