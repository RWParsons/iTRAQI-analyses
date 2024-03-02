
<!-- README.md is generated from README.Rmd. Please edit that file -->

# iTRAQI: injury Treatment & Rehabilitation Accessibility Queensland Index <a href='https://access.healthequity.link/'><img src='www/iTRAQI-hex.png' align="right" height="150" /></a>

This repository includes the code and data used within the iTRAQI shiny
app.

This app is hosted here <https://aushsi.shinyapps.io/itraqi_app/> and
it’s code is available here <https://github.com/RWParsons/iTRAQI_app/>.

The analyses code in this repository is described in the technical
report here <https://eprints.qut.edu.au/235026/>.

### Helpful resources used during this project:

- kriging <https://rpubs.com/nabilabd/118172>
- plots <https://r-spatial.github.io/sf/articles/sf5.html>
- understanding crs
  <https://www.earthdatascience.org/courses/earth-analytics/spatial-data-r/understand-epsg-wkt-and-other-crs-definition-file-types/>
- changing crs
  <https://stackoverflow.com/questions/50372533/changing-crs-of-a-sf-object>
- spatial aggregations
  <https://cengel.github.io/R-spatial/spatialops.html>

## `{targets}` workflow

This project uses a [`{targets}`](https://books.ropensci.org/targets/)
workflow to fit the models and create all the results visualised in the
interactive app.

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x70a5fa6bea6f298d[""Pattern""]:::none
  end
  subgraph Graph
    direction LR
    x2561c370ea702599["remoteness_files"]:::uptodate --> x786302e79631eb8d(["l_remoteness_dlist"]):::uptodate
    x20b8fce94e11cd05(["seifa_files_files"]):::uptodate --> x5f5497709c5ef739["seifa_files"]:::uptodate
    xf635f181b39a30ce["drive_times_files"]:::uptodate --> x15acd9b064c909c4(["d_drive_times"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x03e84a931f36fd6b(["d_silver"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x03e84a931f36fd6b(["d_silver"]):::uptodate
    x0085422ba003396c(["d_acute"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x9f6a140e9d41e9f8(["drive_times_files_files"]):::uptodate --> xf635f181b39a30ce["drive_times_files"]:::uptodate
    xae07be3d7a5496f6(["d_sa1_2021_acute_time"]):::uptodate --> x670286573a6e737f(["dl_file_2021_SA1"]):::uptodate
    x0044d423c4129aa5(["d_sa1_2021_rehab_time"]):::uptodate --> x670286573a6e737f(["dl_file_2021_SA1"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x7115567ab47c0786(["d_future_gold"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x7115567ab47c0786(["d_future_gold"]):::uptodate
    x3c98c5bdbae2f835(["d_sa2_2021_acute_time"]):::uptodate --> x4061f2460c5f975e(["dl_file_2021_SA2"]):::uptodate
    x3d249e379cd8c8bf(["d_sa2_2021_rehab_time"]):::uptodate --> x4061f2460c5f975e(["dl_file_2021_SA2"]):::uptodate
    x140f4dcc1344002d(["d_sa1_2016_acute_time"]):::uptodate --> x8e785e1ce1247c8f(["app_polygons"]):::uptodate
    x17e7029742198b85(["d_sa1_2016_rehab_time"]):::uptodate --> x8e785e1ce1247c8f(["app_polygons"]):::uptodate
    x235ba1189d5ce124(["d_sa2_2016_acute_time"]):::uptodate --> x8e785e1ce1247c8f(["app_polygons"]):::uptodate
    xd957b08abae86042(["d_sa2_2016_rehab_time"]):::uptodate --> x8e785e1ce1247c8f(["app_polygons"]):::uptodate
    x786302e79631eb8d(["l_remoteness_dlist"]):::uptodate --> x8e785e1ce1247c8f(["app_polygons"]):::uptodate
    xe97fee2eed97fb6f(["l_seifa_dlist"]):::uptodate --> x8e785e1ce1247c8f(["app_polygons"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x5c8a4b58701f0195(["d_gold"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x5c8a4b58701f0195(["d_gold"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x9cf1da0d89b39050(["d_future_gold_and_cairns"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x9cf1da0d89b39050(["d_future_gold_and_cairns"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::uptodate --> x3556cb9010710414(["d_acute_kriged_raster"]):::uptodate
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> x3556cb9010710414(["d_acute_kriged_raster"]):::uptodate
    x7115567ab47c0786(["d_future_gold"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x9cf1da0d89b39050(["d_future_gold_and_cairns"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x5c8a4b58701f0195(["d_gold"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    xe85c83d45448032e(["d_platinum"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x03e84a931f36fd6b(["d_silver"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x3c98c5bdbae2f835(["d_sa2_2021_acute_time"]):::uptodate
    x5f5497709c5ef739["seifa_files"]:::uptodate --> xe97fee2eed97fb6f(["l_seifa_dlist"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x8ef184c44b3c9287(["d_sa2_2011_acute_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x235ba1189d5ce124(["d_sa2_2016_acute_time"]):::uptodate
    x85ecf85bc3a92095(["qld_locations_file"]):::uptodate --> x21879eefff325d9d(["d_ids"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::uptodate --> x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate
    x6aff51c44af250ba(["remoteness_files_files"]):::uptodate --> x2561c370ea702599["remoteness_files"]:::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::uptodate --> x5fb43595e3d9b43d(["d_rehab_kriged_raster"]):::uptodate
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> x5fb43595e3d9b43d(["d_rehab_kriged_raster"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> xdd6e281ffd7abb1e(["d_sa1_2011_rehab_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x17e7029742198b85(["d_sa1_2016_rehab_time"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> xe85c83d45448032e(["d_platinum"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> xe85c83d45448032e(["d_platinum"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::uptodate --> xcfed681661a25666(["d_acute_kriged_for_agg"]):::uptodate
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> xcfed681661a25666(["d_acute_kriged_for_agg"]):::uptodate
    x6ea9bfcc13ed2276(["acute_times_file"]):::uptodate --> x0085422ba003396c(["d_acute"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> xb1cba206a277ab8b(["d_sa2_2011_rehab_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> xae07be3d7a5496f6(["d_sa1_2021_acute_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> xd957b08abae86042(["d_sa2_2016_rehab_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x0044d423c4129aa5(["d_sa1_2021_rehab_time"]):::uptodate
    x23fe5c9d10c5ba8b(["d_sa1_2011_acute_time"]):::uptodate --> xb03e5e3c90f2da7c(["dl_file_2011_SA1"]):::uptodate
    xdd6e281ffd7abb1e(["d_sa1_2011_rehab_time"]):::uptodate --> xb03e5e3c90f2da7c(["dl_file_2011_SA1"]):::uptodate
    x786302e79631eb8d(["l_remoteness_dlist"]):::uptodate --> xb03e5e3c90f2da7c(["dl_file_2011_SA1"]):::uptodate
    xe97fee2eed97fb6f(["l_seifa_dlist"]):::uptodate --> xb03e5e3c90f2da7c(["dl_file_2011_SA1"]):::uptodate
    x8ef184c44b3c9287(["d_sa2_2011_acute_time"]):::uptodate --> xf1ace82ee36a732e(["dl_file_2011_SA2"]):::uptodate
    xb1cba206a277ab8b(["d_sa2_2011_rehab_time"]):::uptodate --> xf1ace82ee36a732e(["dl_file_2011_SA2"]):::uptodate
    x786302e79631eb8d(["l_remoteness_dlist"]):::uptodate --> xf1ace82ee36a732e(["dl_file_2011_SA2"]):::uptodate
    xe97fee2eed97fb6f(["l_seifa_dlist"]):::uptodate --> xf1ace82ee36a732e(["dl_file_2011_SA2"]):::uptodate
    x21879eefff325d9d(["d_ids"]):::uptodate --> x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x3d249e379cd8c8bf(["d_sa2_2021_rehab_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x23fe5c9d10c5ba8b(["d_sa1_2011_acute_time"]):::uptodate
    x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::uptodate --> x140f4dcc1344002d(["d_sa1_2016_acute_time"]):::uptodate
    x140f4dcc1344002d(["d_sa1_2016_acute_time"]):::uptodate --> x2138cd44d3ad5669(["dl_file_2016_SA1"]):::uptodate
    x17e7029742198b85(["d_sa1_2016_rehab_time"]):::uptodate --> x2138cd44d3ad5669(["dl_file_2016_SA1"]):::uptodate
    x786302e79631eb8d(["l_remoteness_dlist"]):::uptodate --> x2138cd44d3ad5669(["dl_file_2016_SA1"]):::uptodate
    xe97fee2eed97fb6f(["l_seifa_dlist"]):::uptodate --> x2138cd44d3ad5669(["dl_file_2016_SA1"]):::uptodate
    x235ba1189d5ce124(["d_sa2_2016_acute_time"]):::uptodate --> x6daca8a7a6cdef63(["dl_file_2016_SA2"]):::uptodate
    xd957b08abae86042(["d_sa2_2016_rehab_time"]):::uptodate --> x6daca8a7a6cdef63(["dl_file_2016_SA2"]):::uptodate
    x786302e79631eb8d(["l_remoteness_dlist"]):::uptodate --> x6daca8a7a6cdef63(["dl_file_2016_SA2"]):::uptodate
    xe97fee2eed97fb6f(["l_seifa_dlist"]):::uptodate --> x6daca8a7a6cdef63(["dl_file_2016_SA2"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
```
