A big problem (of many) in the previous version of the app was that it took ages to load a map. This was because leaflet::addPolygons() is VERY slow. 

To mitigate the lag time, we distracted the user with a base map and some reading material while the polygons were loaded in the background, asynchronously. However, if the user opens the app and then clicks to the map page, the app is asynchronously loading the background content to the tour page and then (after a while) has to do the same for the same content on the main map page.  This takes a long time! But after the map content is added to the map, it's fast and reactive to changing filters because we can use these setShape__ functions (https://github.com/rstudio/leaflet/pull/598).

In this version of the app, I am attempting to use leafgl which can a load content onto the map much faster, but unfortunately, the we can't update an existing shape like we can with the standard leaflet::addPolygons() (see: https://github.com/r-spatial/leafgl/issues/85).

The design of the app will have minimal content loaded first (just as before) but as layers are selected, only that layer (in the corresponding fill-colour and filtered selection) will be added to the map, and the previous presented layer removed (rather than re-rendering entire map which would reset the view position).


I had previously hoped that I could make a map that would share all content and only a single layer of polygons (SA1) and update colour and linestring based on the selected layer (grouping SA1 colours into SA2s etc) but that is now gonna get thrown out. I'll leave those outputs in the analysis pipeline incase things change at that leafgl issue #85. The approach that I will now try will be to have polygons/linestrings ready to go at SA1 and SA2 level separately, no need for a lookup to layerid (might not even have a use for layerids at all!) and a single lookup between the filtering variables and selected shapes, and another data.frame/tibble with the popups and fill colors based on already-applied-palettes (might see if this is worthwhile first...) to the values for that area. This will add some additional wrangling to the analyses pipeline but keep the app code relatively simple and hopefully easier to apply to other projects.