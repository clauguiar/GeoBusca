$(document).on("google_point_map_widget:marker_create", function (e, place, lat, lng, locationInputElem, mapWrapID) {
    console.log(place); // google place object
    console.log(locationInputElem); // django widget textarea widget (hidden)
    console.log(lat, lng); // created marker coordinates
    console.log(mapWrapID); // map widget wrapper element ID
});

$(document).on("google_point_map_widget:marker_change", function (e, place, lat, lng, locationInputElem, mapWrapID) {
    console.log(place); // google place object
    console.log(locationInputElem); // django widget textarea widget (hidden)
    console.log(lat, lng);  // changed marker coordinates
    console.log(mapWrapID); // map widget wrapper element ID
});

$(document).on("google_point_map_widget:marker_delete", function (e, lat, lng, locationInputElem, mapWrapID) {
    console.log(locationInputElem); // django widget textarea widget (hidden)
    console.log(lat, lng);  // deleted marker coordinates
    console.log(mapWrapID); // map widget wrapper element ID
})
