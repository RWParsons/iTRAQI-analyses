box::use(
  leaflet,
  mapgl,
)

box::use(
  app / logic / load_shapes,
  app / logic / constants,
  app / logic / utils,
  app / logic / scales_and_palettes,
)

#' @export
make_base_map <- function(show_default_markers = TRUE, ...) {
  d <- load_shapes$stacked_sa1_sa2_polygon_geom |>
    dplyr::left_join(load_shapes$stacked_sa1_sa2_data, by = "CODE")


  acute_raster <- load_shapes$raster_layers$acute_raster |>
    dplyr::mutate(
      id = dplyr::row_number(),
      col = scales_and_palettes$get_palette("acute")(pred)
    )

  acute_raster <- load_shapes$raster_layers$acute_raster |>
    dplyr::mutate(
      pred_norm = round(pred / max(pred), digits = 4),
      pred_col_grp = as.numeric(cut(pred_norm, breaks = seq(from = 0, to = 1, length.out = 255)))
    ) |>
    group_by(pred_col_grp) |>
    mutate(col = scales_and_palettes$get_palette("acute")(pred[1])) |>
    ungroup()

  tb <- distinct(acute_raster, value = pred_col_grp, col) |> as.data.frame()

  test_raster <- tidyterra::as_spatraster(dplyr::select(acute_raster, x, y, value = pred_col_grp), crs = 4326)

  terra::coltab(test_raster) <- tb

    # terra::coltab(test_raster)[[1]][terra::coltab(test_raster)[[1]] == 255] <- 254

  # try making the coltb go for values from 0 to 255 (255 rows)
  # browser()
  # plot(test_raster)
  # test_raster <- rast(ncols = 100, nrows = 100, vals = 1:5)




  m <- mapgl$mapboxgl(mapgl$mapbox_style("streets")) |>
    mapgl$fit_bounds(load_shapes$state_boundary) |>
    # add polygons layer between base map and road paths
    mapgl$add_fill_layer(
      id = "polygons",
      source = d,
      fill_opacity = 0.5,
      fill_color = "blue",
      before_id = "tunnel-path"
    ) |>
    # add rasters
    add_image_source(
      id = "acute_raster_data",
      data = test_raster
    ) |>
    mapgl$add_raster_layer(
      id = "acute_raster_layer",
      source = "acute_raster_data"
    )

  mapgl$renderMapboxgl(m)
}

add_image_source <- function(map, id, url = NULL, data = NULL, coordinates = NULL, colors = NULL) {
  # browser()
  if (!is.null(data)) {
    if (inherits(data, "RasterLayer")) {
      data <- terra::rast(data)
    }

    # data <- terra::project(data, "EPSG:4326")

    if (terra::nlyr(data) == 3) {
      # For RGB raster
      png_path <- tempfile(fileext = ".png")
      terra::writeRaster(data, png_path, overwrite = TRUE)
      url <- base64enc::dataURI(file = png_path, mime = "image/png")
    } else {
      if (terra::has.colors(data)) {
        # If the raster already has a color table
        coltb <- terra::coltab(data)
      } else {
        # Prepare color mapping for single-band raster
        if (is.null(colors)) {
          colors <- grDevices::colorRampPalette(c("#440154", "#3B528B", "#21908C", "#5DC863", "#FDE725"))(256)
        } else if (length(colors) < 256) {
          colors <- grDevices::colorRampPalette(colors)(256)
        }
        # browser()

        data <- data / max(terra::values(data), na.rm = TRUE) * 254
        data <- round(data)
        data[is.na(terra::values(data))] <- 255
        coltb <- data.frame(value = 0:255, col = colors)

        # Create color table
        terra::coltab(data) <- coltb
      }

      png_path <- tempfile(fileext = ".png")
      terra::writeRaster(data, png_path, overwrite = TRUE, NAflag = 255, datatype = "INT1U")
      url <- base64enc::dataURI(file = png_path, mime = "image/png")


    }
    # Compute coordinates if not provided
    if (is.null(coordinates)) {
      ext <- terra::ext(data)
      coordinates <- list(
        unname(c(ext[1], ext[4])),  # top-left
        unname(c(ext[2], ext[4])),  # top-right
        unname(c(ext[2], ext[3])),  # bottom-right
        unname(c(ext[1], ext[3]))   # bottom-left
      )
    }
  }

  if (is.null(url)) {
    stop("Either 'url' or 'data' must be provided.")
  }

  source <- list(
    id = id,
    type = "image",
    url = url,
    coordinates = coordinates
  )

  if (inherits(map, "mapboxgl_proxy") || inherits(map, "maplibre_proxy")) {
    proxy_class <- if (inherits(map, "mapboxgl_proxy")) "mapboxgl-proxy" else "maplibre-proxy"
    map$session$sendCustomMessage(proxy_class, list(id = map$id, message = list(type = "add_source", source = source)))
  } else {
    map$x$sources <- c(map$x$sources, list(source))
  }

  return(map)
}


#' @export
add_map_content <- function(proxy_map, map_content, ...) {
  proxy_map |>
    mapgl$set_filter(
      "polygons",
      c("in", "CODE", sample(load_shapes$stacked_sa1_sa2_polygon_geom$CODE, 120))
    )
}

centre_icons <- leaflet$iconList(
  acute = leaflet$makeIcon(
    iconUrl = "static/images/acute-centre.png",
    iconWidth = 50,
    iconHeight = 50
  ),
  rehab = leaflet$makeIcon(
    iconUrl = "static/images/rehab-centre.png",
    iconWidth = 40,
    iconHeight = 40
  ),
  rsq = leaflet$makeIcon(
    iconUrl = "static/images/rsq.png",
    iconWidth = 50,
    iconHeight = 30
  ),
  qas = leaflet$makeIcon(
    iconUrl = "static/images/qas.png",
    iconWidth = 10,
    iconHeight = 10
  )
)
