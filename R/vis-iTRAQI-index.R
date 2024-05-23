get_iTRAQI_vis_objs <- function(shapes,
                                palette_file,
                                kriged_rehab,
                                kriged_acute,
                                itraqi_breaks,
                                get_iTRAQI_index) {
  bins <- c(0, 60, 120, 180, 240, 300, 360, 900, 1200)

  palBin <- colorBin("YlOrRd", domain = min(bins):max(bins), bins = bins, na.color = "transparent")
  palBin_hours <- colorBin("YlOrRd", domain = min(bins):max(bins) / 60, bins = bins / 60, na.color = "transparent")

  palNum1 <- colorNumeric(c(palBin(bins[1]), palBin(bins[2])), domain = 0:60, na.color = "transparent")
  palNum2 <- colorNumeric(c(palBin(bins[2]), palBin(bins[3])), domain = 60:120, na.color = "transparent")
  palNum3 <- colorNumeric(c(palBin(bins[3]), palBin(bins[4])), domain = 120:180, na.color = "transparent")
  palNum4 <- colorNumeric(c(palBin(bins[4]), palBin(bins[5])), domain = 180:240, na.color = "transparent")
  palNum5 <- colorNumeric(c(palBin(bins[5]), palBin(bins[6])), domain = 240:300, na.color = "transparent")
  palNum6 <- colorNumeric(c(palBin(bins[6]), palBin(bins[7])), domain = 300:360, na.color = "transparent")
  palNum7 <- colorNumeric(c(palBin(bins[7]), palBin(bins[8])), domain = 360:900, na.color = "transparent")
  palNum8 <- colorNumeric(c(palBin(bins[8]), "#000000"), domain = 900:1200, na.color = "transparent")
  # palNum9 <- colorNumeric(c(palBin(bins[9]), "#000000"), domain = 900:1200, na.color = "transparent")

  palNum <- function(x) {
    suppressWarnings(case_when(
      x < 60 ~ palNum1(x),
      x < 120 ~ palNum2(x),
      x < 180 ~ palNum3(x),
      x < 240 ~ palNum4(x),
      x < 300 ~ palNum5(x),
      x < 360 ~ palNum6(x),
      x < 900 ~ palNum7(x),
      x < 1200 ~ palNum8(x),
      x >= 1200 ~ "#000000",
      TRUE ~ "transparent"
    ))
  }

  palNum_hours <- function(x) {
    palNum(x * 60)
  }

  iTRAQI_acute_breaks <- itraqi_breaks$iTRAQI_acute_breaks
  iTRAQI_rehab_breaks <- itraqi_breaks$iTRAQI_rehab_breaks

  polygons <- shapes$polygons |>
    mutate(index = get_iTRAQI_index(acute_mins = value_acute, rehab_mins = value_rehab))

  qld_SA2s <- filter(polygons, SA_level == 2)
  qld_SA1s <- filter(polygons, SA_level == 1)

  get_iTRAQI_bins <- function() {
    unique_rehab_levels <- cut(0, breaks = iTRAQI_rehab_breaks) |> levels()
    unique_rehab_levels <- LETTERS[1:length(unique_rehab_levels)]

    unique_acute_levels <- cut(0, breaks = iTRAQI_acute_breaks) |> levels()
    unique_acute_levels <- 1:length(unique_acute_levels)

    grid <- expand.grid(acute = unique_acute_levels, rehab = unique_rehab_levels)
    grid$iTRAQI_index <- paste0(grid$acute, grid$rehab)
    grid <- grid[grid$iTRAQI_index %in% unique(polygons$index), ]
    as.factor(grid$iTRAQI_index)
  }

  iTRAQI_bins <- get_iTRAQI_bins()

  index_palette <- read.csv(palette_file)

  paliTRAQI <- colorFactor(
    # https://stackoverflow.com/questions/44269655/ggplot-rcolorbrewer-extend-and-apply-to-factor-data
    index_palette$hex2,
    levels = levels(iTRAQI_bins),
    ordered = FALSE
  )

  rehab_raster <- kriged_rehab |>
    as_tibble() |>
    select(x = X, y = Y, pred = var1.pred)

  acute_raster <- kriged_acute |>
    as_tibble() |>
    select(x = X, y = Y, pred = var1.pred)

  list(
    qld_SA2s = qld_SA2s,
    qld_SA1s = qld_SA1s,
    paliTRAQI = paliTRAQI,
    rehab_raster = rehab_raster,
    acute_raster = acute_raster,
    palNum = palNum,
    iTRAQI_acute_breaks = iTRAQI_acute_breaks,
    iTRAQI_rehab_breaks = iTRAQI_rehab_breaks,
    bins = bins,
    iTRAQI_bins = iTRAQI_bins,
    palNum_hours = palNum_hours,
    palBin_hours = palBin_hours,
    palBin = palBin
  )
}
