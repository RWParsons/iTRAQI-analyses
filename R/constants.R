silver_locs <- c(
  "Cairns Hospital",
  "Townsville University Hospital",
  "Central West Sub-Acute Service",
  "Rockhampton Hospital",
  "Roma Hospital",
  "Gympie Hospital",
  "Sunshine Coast University Hospital",
  "Brain Injury Rehabilitation Unit",
  "Gold Coast University Hospital",
  "Sarina Hospital",
  "RBWH",
  "Logan Hospital",
  "Redcliffe Hospital",
  "Maleny Hospital",
  "Prince Charles Hospital",
  "Geriatric Assessment Rehabilitation Unit",
  "Brighton Bain Injury Service"
)

future_gold_locs <- c(
  "Townsville University Hospital",
  "Sunshine Coast University Hospital",
  "Brain Injury Rehabilitation Unit",
  "RBWH",
  "Gold Coast University Hospital"
)

future_gold_and_cairns_locs <- c(
  future_gold_locs,
  "Cairns Hospital"
)

gold_locs <- c(
  "Townsville University Hospital",
  "Brain Injury Rehabilitation Unit"
)

platinum_locs <- c(
  "Brain Injury Rehabilitation Unit"
)

crs_for_analyses <- list(
  crs_num = 4326,
  proj4str = "+proj=lcc +lat_0=-32 +lon_0=135 +lat_1=-28 +lat_2=-36 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs"
)

output_dir <- here::here("output")

app_data_dir <- here::here("app/app/data")

dl_file_frontpages_dir <- "data/downloadable_data_templates/"


# make cell sizes 1 per square km for aggregations and 1 per 3 square km for raster (for faster loading)
CELL_SIZE_METERS <- 1000
cell_size_agg <- CELL_SIZE_METERS / 111320
cell_size_raster <- cell_size_agg * 3
