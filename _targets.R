library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tidyverse", "sf", "glue", "leaflet", "emojifont", "flextable"),
  format = "rds",
  controller = crew::crew_controller_local(workers = 4)
)
options(clustermq.scheduler = "multiprocess")
tar_source()

list(
  # Main data wrangling and model fitting #####################################
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
    get_input_shapes(agg_grid_cellsize = cell_size_agg, raster_grid_cellsize = cell_size_raster)
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
      kriged_spdf = d_acute_kriged_for_agg$kriged_layer,
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
      kriged_spdf = d_acute_kriged_for_agg$kriged_layer,
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
      kriged_spdf = d_acute_kriged_for_agg$kriged_layer,
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
      kriged_spdf = d_acute_kriged_for_agg$kriged_layer,
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
      kriged_spdf = d_acute_kriged_for_agg$kriged_layer,
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
      kriged_spdf = d_acute_kriged_for_agg$kriged_layer,
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
  tar_target(
    app_raster,
    create_app_raster(
      rehab = d_rehab_kriged_raster$kriged_layer,
      acute = d_acute_kriged_raster$kriged_layer
    ),
    format = "file"
  ),
  tar_target(
    app_locations_and_times,
    create_app_locs_and_times(
      l_travel_times
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
  ),

  # visualisations ############################################################
  tar_target(
    centre_coords_file,
    "data/inputs-for-visualisations/centres.csv",
    format = "file"
  ),
  tar_target(
    d_centre_coords,
    read.csv(centre_coords_file)
  ),
  tar_target(
    qas_locations_file,
    "data/inputs-for-visualisations/qas_locations.csv",
    format = "file"
  ),
  tar_target(
    d_qas_locations,
    read.csv(qas_locations_file)
  ),
  tar_target(
    rsq_locations_file,
    "data/inputs-for-visualisations/rsq_locations.csv",
    format = "file"
  ),
  tar_target(
    d_rsq_locations,
    read.csv(rsq_locations_file)
  ),
  tar_target(
    d_icons,
    get_icons(icons_dir = "data/icons")
  ),
  tar_target(
    vis_shapes,
    get_vis_datasets(
      polygons = app_polygons,
      qld_boundary = d_input_shapes$qld_state_boundary,
      centre_coords = d_centre_coords,
      qas_locations = d_qas_locations,
      rsq_locations = d_rsq_locations,
      town_locations = d_ids,
      centre_icons = d_icons$centre_icons
    )
  ),
  tar_target(
    plotting_utils,
    get_plotting_utils()
  ),
  tar_target(
    palette_file,
    "data/inputs-for-visualisations/index_palette.csv"
  ),
  tar_target(
    itraqi_list,
    get_iTRAQI_vis_objs(
      shapes = vis_shapes,
      palette_file = palette_file,
      kriged_rehab = d_rehab_kriged_raster$kriged_layer,
      kriged_acute = d_acute_kriged_raster$kriged_layer
    )
  ),
  # make maps
  tar_target(
    qas_map,
    make_qas_map(vis_shapes, plotting_utils)
  ),
  tar_target(
    town_locations_map,
    make_towns_map(vis_shapes, plotting_utils)
  ),
  tar_target(
    rsq_maps,
    make_rsq_maps(vis_shapes, plotting_utils)
  ),
  tar_target(
    major_regional_services_map,
    make_major_regional_services_map(vis_shapes, plotting_utils)
  ),
  tar_target(
    inset_maps,
    make_inset_maps(
      vis_shapes,
      centre_coords = d_centre_coords,
      plotting_utils,
      medal_icon_paths = d_icons$medal_icon_paths
    )
  ),
  tar_target(
    iTRAQI_sa2_map,
    make_itraqi_sa2_map(itraqi_list, plotting_utils)
  ),
  tar_target(
    iTRAQI_sa1_map,
    make_itraqi_sa1_map(itraqi_list, plotting_utils)
  ),
  tar_target(
    iTRAQI_acute_maps,
    make_acute_maps(itraqi_list, plotting_utils)
  ),
  tar_target(
    iTRAQI_rehab_maps,
    make_rehab_maps(itraqi_list, plotting_utils)
  ),
  tar_target(
    iTRAQI_legends,
    make_legends(itraqi_list, plotting_utils)
  ),

  # make tables
  tar_target(
    iTRAQI_tables,
    make_itraqi_counts_tbls(itraqi_list)
  ),
  tar_target(
    index_palette_table,
    make_palette_table(itraqi_list)
  )
)
