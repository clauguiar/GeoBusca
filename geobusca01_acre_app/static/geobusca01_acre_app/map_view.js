var map_view;


    function init(){
        map_view = new ol.Map({
            target:'map_view',
            renderer:'canvas',
            view: new ol.View({
                projection: 'EPSG:3857',
                center: ol.proj.transform([19, 52], 'EPSG:4326', 'EPSG:3857'),
                zoom:6,
            })
        });
        var osm = new ol.layer.Tile({
            source: new ol.source.OSM()
        });

var PointLayer = new ol.layer.Vector({
  title: 'Point',
    source: new ol.source.KML({
        projection:new ol.proj.get("EPSG:3857"),
    url:'http://localhost:8000/geobuscapp/historico/',
    extractStyles: false
    }),
  style: (function() {
  var textStroke = new ol.style.Stroke({
    color: 'yellow',
    width: 3
  });
  var textFill = new ol.style.Fill({
    color: 'black'
  });
  return function(feature, resolution) {
    return [new ol.style.Style({
      image: new ol.style.Circle({
      radius: 7,
      fill: new ol.style.Fill({color: 'yellow'}),
      stroke: new ol.style.Stroke({color: 'red'})
    }),
      text: new ol.style.Text({
        font: '11px arial,sans-serif',
        text: feature.get('name'),
        fill: textFill,
        stroke: textStroke,
        offsetX: 25,
        offsetY: -10
      })
    })];
  };
})()

});
