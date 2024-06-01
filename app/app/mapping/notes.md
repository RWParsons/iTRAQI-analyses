A big problem (of many) in the previous version of the app was that it took ages to load a map. This was because leaflet::addPolygons() is VERY slow. 

To mitigate the lag time, we distracted the user with a base map and some reading material while the polygons were loaded in the background, asynchronously. However, if the user opens the app and then clicks to the map page, the app is asynchronously loading the background content to the tour page and then (after a while) has to do the same for the same content on the main map page.  This takes a long time! But after the map content is added to the map, it's fast and reactive to changing filters because we can use these setShape__ functions (https://github.com/rstudio/leaflet/pull/598).

In this version of the app, I am attempting to use leafgl which can a load content onto the map much faster, but unfortunately, the we can't update an existing shape like we can with the standard leaflet::addPolygons() (see: https://github.com/r-spatial/leafgl/issues/85).

The design of the app will have minimal content loaded first (just as before) but as layers are selected, only that layer (in the corresponding fill-colour and filtered selection) will be added to the map, and the previous presented layer removed (rather than re-rendering entire map which would reset the view position).
