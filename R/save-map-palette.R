save_app_palette <- function(itraqi_list) {
  # save all the relevant objects for reproducing the colour scales/palettes in
  # the app without having to repeat the same code there

  l_palette_objs <- list(
    bins_index = itraqi_list$iTRAQI_bins,
    bins_mins = itraqi_list$bins,
    iTRAQI_acute_breaks = itraqi_list$iTRAQI_acute_breaks,
    iTRAQI_rehab_breaks = itraqi_list$iTRAQI_rehab_breaks,
    paliTRAQI = itraqi_list$paliTRAQI,
    palNum = itraqi_list$palNum,
    palNum_hours = itraqi_list$palNum_hours,
    palBin_hours = itraqi_list$palBin_hours,
    palBin = itraqi_list$palBin
  )

  saveRDS(l_palette_objs, file.path(app_data_dir, "palette_list.rds"))
  file.path(app_data_dir, "palette_list.rds")
}
