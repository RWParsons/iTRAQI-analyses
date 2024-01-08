
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
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- x0a52b03877696646([""Outdated""]):::outdated
    x0a52b03877696646([""Outdated""]):::outdated --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x70a5fa6bea6f298d[""Pattern""]:::none
  end
  subgraph Graph
    direction LR
    x6ea9bfcc13ed2276(["acute_times_file"]):::uptodate --> x0085422ba003396c(["d_acute"]):::uptodate
    x21879eefff325d9d(["d_ids"]):::uptodate --> x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate
    x7115567ab47c0786(["d_future_gold"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x9cf1da0d89b39050(["d_future_gold_and_cairns"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x5c8a4b58701f0195(["d_gold"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    xe85c83d45448032e(["d_platinum"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x03e84a931f36fd6b(["d_silver"]):::uptodate --> x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate
    x0085422ba003396c(["d_acute"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x95cfa4f70fea9a21(["l_all_drive_times"]):::uptodate --> x44f0a0e2845803f1(["l_travel_times"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::outdated --> x5fb43595e3d9b43d(["d_rehab_kriged_raster"]):::outdated
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> x5fb43595e3d9b43d(["d_rehab_kriged_raster"]):::outdated
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x03e84a931f36fd6b(["d_silver"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x03e84a931f36fd6b(["d_silver"]):::uptodate
    x9f6a140e9d41e9f8(["drive_times_files_files"]):::uptodate --> xf635f181b39a30ce["drive_times_files"]:::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x5c8a4b58701f0195(["d_gold"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x5c8a4b58701f0195(["d_gold"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::outdated --> x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::outdated
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> x6b9c58fabbe5d5ac(["d_rehab_kriged_for_agg"]):::outdated
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x7115567ab47c0786(["d_future_gold"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x7115567ab47c0786(["d_future_gold"]):::uptodate
    x85ecf85bc3a92095(["qld_locations_file"]):::uptodate --> x21879eefff325d9d(["d_ids"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::outdated --> xcfed681661a25666(["d_acute_kriged_for_agg"]):::outdated
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> xcfed681661a25666(["d_acute_kriged_for_agg"]):::outdated
    xf635f181b39a30ce["drive_times_files"]:::uptodate --> x15acd9b064c909c4(["d_drive_times"]):::uptodate
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> xe85c83d45448032e(["d_platinum"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> xe85c83d45448032e(["d_platinum"]):::uptodate
    x831ee0369a2a91ad(["d_input_shapes"]):::outdated --> x3556cb9010710414(["d_acute_kriged_raster"]):::outdated
    x44f0a0e2845803f1(["l_travel_times"]):::uptodate --> x3556cb9010710414(["d_acute_kriged_raster"]):::outdated
    x15acd9b064c909c4(["d_drive_times"]):::uptodate --> x9cf1da0d89b39050(["d_future_gold_and_cairns"]):::uptodate
    x24fc4b6a7e38688b(["d_island_rehab_times"]):::uptodate --> x9cf1da0d89b39050(["d_future_gold_and_cairns"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
```
