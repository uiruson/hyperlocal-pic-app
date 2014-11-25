var map;
var polylineCoordinates = [];
var origin;
var markers;
var MY_MAPTYPE_ID = 'custom_style';

//Grabbing lat, lon from user's pictures and instagram's pictures
$.getJSON( '/javascript/location.json', function(data) { 
  $.each( data.markers, function(i, m) {
      polylineCoordinates.push(new google.maps.LatLng(m.latitude, m.longitude));
  });
  origin = new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude);
  console.log("origin: " + origin);
});

function initialize() {
  var featureOpts = [
    {
      stylers: [
        { visibility: 'simplified' },
        { gamma: 1.8 },
        { weight: 0.9 }
      ]
    },
    {
      elementType: 'labels',
      stylers: [
        { visibility: 'on' }
      ]
    },
    {
      featureType: 'water',
      stylers: [
        { color: '#56c2d6' }
      ]
    }
  ];

  var mapOptions = {
     zoom: 15,
      center: origin,
      mapTypeControlOptions: {
        mapTypeIds: [google.maps.MapTypeId.ROADMAP, MY_MAPTYPE_ID]
      },
      mapTypeId: MY_MAPTYPE_ID
  }

  map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
  var styledMapOptions = {
    name: 'Custom Style'
  };

  var customMapType = new google.maps.StyledMapType(featureOpts, styledMapOptions);

  map.mapTypes.set(MY_MAPTYPE_ID, customMapType);
  populateMarkersAndRoutes();
}

function populateMarkersAndRoutes(){
   $.getJSON('/javascript/location.json',
      function(data){
        var infoWindow = new google.maps.InfoWindow()
        for(var x=0; x < data.markers.length; x++){
            origin   = new google.maps.LatLng(data.origins[0].latitude, data.origins[0].longitude);
            
            var originMarker = new google.maps.Marker({
                position: origin,
                map: map,
                icon: '/images/map-marker.png'
            });
        
            var markerImage = {
              url: ''+data.images[x].src,
              size: new google.maps.Size(50, 50)
            }

            //Adding marker as instagram image
            var marker = new google.maps.Marker({
                position: polylineCoordinates[x],
                map: map,
                icon: markerImage,
                optimized: false
            });

            google.maps.event.addListener(marker, 'click', (function(marker, x) {
                return function() {
                  infoWindow.setContent('<img src="' + data.images[x].src + '" />');
                  infoWindow.open(map, marker);
                }
            })(marker, x));

            //Drawing routes           
            var route = new google.maps.Polyline({
              map: map,
              path: [origin, polylineCoordinates[x]],
              strokeColor: '#fed282',
              strokeOpacity: 1.0,
              strokeWeight: 2
            });
        }
            
      }
  );
}
google.maps.event.addDomListener(window, 'load', initialize);  