$(function() {
  $.getJSON( 'javascript/location.json', function(data) { 
    $('#map_canvas').gmap('addMarker', { 'position': new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude), 'bounds':true , 'icon': 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'} );
    
    $.each( data.markers, function(i, m) {
      var polylinesCoords = []
      polylinesCoords[i] = []
      polylinesCoords[i].push(new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude));
      
      $('#map_canvas').gmap('addMarker', { 'position': new google.maps.LatLng(m.latitude, m.longitude), 'bounds':true} );
      polylinesCoords[i].push(new google.maps.LatLng(m.latitude, m.longitude));
      console.log("polylinesCoords inside for loop = " + polylinesCoords);
      $('#map_canvas').gmap({'center': new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude)}).bind('init', function() {
        $('#map_canvas').gmap('addShape', 'Polyline', {
        'path': polylinesCoords[i],
        'strokeColor': '#fff000',
        'strokeThickness': 5,
        'strokeDashArray': '5 2' 
        });
      });
    });
  });    
});
