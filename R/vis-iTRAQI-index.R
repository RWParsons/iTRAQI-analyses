get_iTRAQI_vis_objs <- function(shapes,
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
  palNum8 <- colorNumeric(c(palBin(bins[8]), "#5F004E"), domain = 900:1200, na.color = "transparent")

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
      x >= 1200 ~ "#5F004E",
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

  index_palette <- tibble(
    # from Susanna's email and shown on issue #1 on GitHub
    index = c(
      "1A", "2A", "3A", "3B", "3C", "4A",
      "4B", "4C", "5B", "5C"
    ), r = c(
      255L, 255L, 255L, 255L, 255L,
      230L, 220L, 196L, 140L, 95L
    ), g = c(
      230L, 191L, 136L, 110L, 78L,
      60L, 30L, 0L, 0L, 0L
    ), b = c(
      153L, 47L, 83L, 36L, 19L, 66L, 72L,
      78L, 78L, 78L
    )
  )

  index_palette$hex <- NA

  for (i in 1:nrow(index_palette)) {
    index_palette$hex[i] <- rgb(
      r = index_palette$r[i],
      g = index_palette$g[i],
      b = index_palette$b[i],
      maxColorValue = 255
    )
  }

  paliTRAQI <- colorFactor(
    # https://stackoverflow.com/questions/44269655/ggplot-rcolorbrewer-extend-and-apply-to-factor-data
    index_palette$hex,
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
    iTRAQI_index = get_iTRAQI_index,
    index_palette = index_palette,
    bins = bins,
    iTRAQI_bins = iTRAQI_bins,
    palNum_hours = palNum_hours,
    palBin_hours = palBin_hours,
    palBin = palBin
  )
}
