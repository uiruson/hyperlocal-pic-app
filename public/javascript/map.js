$(function() {
  $.getJSON( 'javascript/location.json', function(data) { 
      $('#map_canvas').gmap('addMarker', { 'position': new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude), 
        'bounds':true});
      console.log("images count = " + data.images.length);
      $.each( data.markers, function(i, m) {
        var polylinesCoords = []
        polylinesCoords[i] = []
        polylinesCoords[i].push(new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude));
        
        $('#map_canvas').gmap('addMarker', { 'position': new google.maps.LatLng(m.latitude, m.longitude), 
          'bounds':true, 
          'icon': new google.maps.MarkerImage( 
           data.images[i].src, 
           new google.maps.Size(50, 50))
        },  
          function(map,marker) {
            $(marker).click(function() {
              console.log(i);
                $('#map_canvas').gmap('openInfoWindow', { 'content': "<img src='"+ data.images[i].src +"' />" }, this)
            });

        });
        polylinesCoords[i].push(new google.maps.LatLng(m.latitude, m.longitude));
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