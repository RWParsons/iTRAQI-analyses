var mapsPlaceholder = [];
L.Map.addInitHook(function () {
   mapsPlaceholder.push(this);
});

function open_popup(id) {
   console.log('open popup for ' + id);
   mapsPlaceholder[0].eachLayer(function(l) {
      if (l.options && l.options.layerId == id) {
         l.openPopup();
      }
   });
}
