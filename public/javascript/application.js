<<<<<<< HEAD
$(document).ready(function(){

  // second page should be invisible at the beginning
  // $('#second-page').css({display : "none"});

  // login/register panel invisible at the beginning
  $('#right-panel-register').css({display : "none"});

  // clicking on the arrow makes the side panel visible
  // $('#right-panel-link').on('click', function(){
  //   console.log("clicked the arrow");
  // });
  $('#right-panel-link').panelslider({side: 'right', clickClose: false, duration: 200 });

  //clicking on register in the side panel shows the registration form
  // and makes the login form disappear
  $('#register').on('click', function(){
    $('#register-button').hide();
    $('#right-panel-login').css({display : "none"});
    $('#right-panel-register').css({display : "block"});
  })


  // // SECOND PAGE
  // //clicking on the loggin button makes the second page visible
  $('#login-button').on('click', function(){
    console.log("clicked login");
    $('#first-page').hide();
    $('#second-page').show();
  });

  $('#upload-panel-button').on('click', function(){
     var uploadPanel = $('.upload-panel');
     if (uploadPanel.is(':hidden')) {
        uploadPanel.slideDown(300);
        $(this).css({display : "none"})
     }
  });

  //clicking on "upload" to upload the picture closes the panel
  //the upload and sign out buttons become visible again
  $('#upload-picture').on('click', function(){
    console.log("clicked upload button")
    var uploadPanel = $('.upload-panel');
    uploadPanel.slideUp(300);
    $('#upload-panel-button').css({display : "block"});
  });

  //same behavior as clicking on the "upload button"
  $('#cancel-upload').on('click', function(){
    console.log("clicked upload button")
    var uploadPanel = $('.upload-panel');
    uploadPanel.slideUp(300);
    $('#upload-panel-button').css({display : "block"});
  });

  // $('.placeholder').on('click', function(){
  //   console.log("clicked on picture");
  // });
=======
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
>>>>>>> 39aaddaabc5bbdb2540d385da54fb5e95037f448
});


