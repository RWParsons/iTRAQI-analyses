create_hex <- function(iTRAQI_list) {
  p <-
    ggplot() +
    geom_sf(
      data = iTRAQI_list$qld_SA2s, fill = iTRAQI_list$paliTRAQI(iTRAQI_list$qld_SA2s$index)
    ) +
    theme_void()
  
  hexSticker::sticker(
    p,
    package="iTRAQI", p_size=20, 
    s_x=1, s_y=.8, s_width=1.4, s_height=1.2,
    filename="www/iTRAQI-hex.png"
  )
  "www/iTRAQI-hex.png"
}