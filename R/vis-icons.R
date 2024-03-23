get_icons <- function(icons_dir) {
  webshot_dims <- list(
    vheight = 5000,
    vwidth = 5000
  )

  icon_width_multiplier <- webshot_dims$vwidth / 992
  icon_height_multiplier <- webshot_dims$vheight / 992


  acute_fp <- file.path(icons_dir, "acute_care.png")
  rehab_fp <- file.path(icons_dir, "rehab_care.png")
  rsq_fp <- file.path(icons_dir, "rsq.png")
  qas_fp <- file.path(icons_dir, "qas.png")

  centre_icons <- iconList(
    acute = makeIcon(
      iconUrl = acute_fp,
      iconWidth = 50 * icon_width_multiplier,
      iconHeight = 50 * icon_height_multiplier
    ),
    rehab = makeIcon(
      iconUrl = rehab_fp,
      iconWidth = 40 * icon_width_multiplier,
      iconHeight = 40 * icon_height_multiplier
    ),
    rsq = makeIcon(
      iconUrl = rsq_fp,
      iconWidth = 50 * icon_width_multiplier,
      iconHeight = 30 * icon_height_multiplier
    ),
    qas = makeIcon(
      iconUrl = qas_fp,
      iconWidth = 10 * icon_width_multiplier,
      iconHeight = 10 * icon_height_multiplier
    )
  )

  medal_icon_paths <- list(
    gold = file.path(icons_dir, "gold_medal.png"),
    silver = file.path(icons_dir, "silver_medal.png")
  )

  list(
    centre_icons = centre_icons,
    medal_icon_paths = medal_icon_paths
  )
}
