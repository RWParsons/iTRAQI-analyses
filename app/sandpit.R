library(rdeck)
library(dplyr)
library(sf)
library(leaflet)

pk <- "pk.eyJ1IjoicmV4d3AiLCJhIjoiY2x3bGJraW5xMGFsNDJrcGdqeWZmOTl2NiJ9.Q7FfS7c2JnQSSUzcVj8mnA"
sk <- "sk.eyJ1IjoicmV4d3AiLCJhIjoiY2x3cmV6d2ppMDAyMDJqb2ZlaGx4MDVtaCJ9.4BMMrGUN8YIuKkUqcyKD3w"
options(rdeck.mapbox_access_token = pk)

pal <- function(x) {
  sample(c("#ffffff", "#000fff"), size = length(x), replace = TRUE)
}

sa1s_qld <- strayr::read_absmap("sa12021") |>
  st_transform(4326) |>
  filter(state_name_2021 == "Queensland") |>
  mutate(sa1_code_2021 = as.numeric(sa1_code_2021))

m_poly <- sa1s_qld |>
  filter(sa1_code_2021 == "30805153502") |>
  st_cast("POLYGON")

leaflet() |>
  addTiles() |>
  leafgl::addGlPolygons(data = m_poly)


leaflet() |>
  addTiles() |>
  leafgl::addGlPolygons(data = sa1s_qld)



leaflet() |>
  addTiles() |>
  addPolygons(data = sa1s_qld, label = sa1s_qld$sa1_code_2021)



rdeck(
  initial_bounds = st_bbox(sa1s_qld)
) |>
  add_polygon_layer(
    data = rename(sa1s_qld, polygon = geometry),
    get_fill_color = scale_color_linear(sa1_code_2021, palette = pal),
    line_width_min_pixels = 0.1,
    line_width_max_pixels = 1,
    line_width_scale = 2,
    get_line_color = "#ffffff"
  )



library(rdeck)
library(shiny)
shinyApp(
  ui = fillPage(
    rdeckOutput("map", height = "100%"),
  ),
  server = function(input, output) {
    output$map <- renderRdeck(
      rdeck(
        map_style = mapbox_dark(),
        layer_selector = TRUE,
        initial_bounds = st_bbox(sa1s_qld)
      ) |>
        add_mvt_layer(
          id = "test",
          data = tile_json("mapbox.mapbox-streets-v8"),
          # pickable = TRUE, tooltip = TRUE,
          get_text = rlang::sym("name"),
          get_fill_color = "#FFFFFFFF",
          point_type = "text"
        ) #|>
      # add_polygon_layer(
      #   data = rename(sa1s_qld, polygon = geometry)
      # )
    )
  }
)


library(mapdeck)
key <- "pk.eyJ1IjoicmV4d3AiLCJhIjoiY2x3bGJraW5xMGFsNDJrcGdqeWZmOTl2NiJ9.Q7FfS7c2JnQSSUzcVj8mnA"
set_token(key)

library(geojsonsf)

# sf <- geojsonsf::geojson_sf("https://symbolixau.github.io/data/geojson/SA2_2016_VIC.json")

mapdeck(
  style = mapdeck_style("dark")
) %>%
  add_polygon(
    data = sf,
    layer = "polygon_layer",
    fill_colour = "SA2_NAME16"
  )
#> default

df <- melbourne ## data.frame with encoded polylnies
df$elevation <- sample(100:5000, size = nrow(df))
df$info <- paste0("<b>SA2 - </b><br>", df$SA2_NAME)

mapdeck(
  style = mapdeck_style("dark"),
  location = c(145, -38),
  zoom = 8
) %>%
  add_polygon(
    data = sa1s_qld
    # , polyline = "geometry"
    , layer = "polygon_layer",
    fill_colour = "SA2_NAME",
    elevation = "elevation",
    tooltip = "info",
    legend = TRUE
  )
