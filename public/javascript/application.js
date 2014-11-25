$(function() {

 var pathname = window.location.pathname;
 var imgId;

 if (pathname.indexOf("/instagram_images/") >= 0){
    imgId = pathname.replace('/instagram_images/','');
    $('#userImg-'+imgId+' img').css('background-color','#fee268');
 }
 
 $('#right-panel-register').css({display : "none"});
 $('#right-panel-link').panelslider({side: 'right', clickClose: false, duration: 500 });
  //clicking on register in the side panel shows the registration form
  // and makes the login form disappear
  $('#register').on('click', function(){
    $('#right-panel-login').css({display : "none"});
    $('#right-panel-register').css({display : "block"});
    $('#register-button').hide();
  });

  $('#upload-panel-button').on('click', function(){
     var uploadPanel = $('.upload-panel');
     if (uploadPanel.is(':hidden')) {
      var height = $('.upload-panel').outerHeight(true);
      $('#second-page').animate({'margin-top': height+'px'}, 1000);
      uploadPanel.slideDown(1000);
      $(this).css({display : "none"})

     }
  });

  //clicking on "upload" to upload the picture closes the panel
  //the upload and sign out buttons become visible again
  $('#upload-picture').on('click', function(){
    console.log("clicked upload button")
    var uploadPanel = $('.upload-panel');
    uploadPanel.slideUp(1000);
    $('#second-page').animate({'margin-top': '0px'}, 1000);
    $('#upload-panel-button').css({display : "block"});
  });

  //same behavior as clicking on the "upload button"
  $('#cancel-upload').on('click', function(){
    console.log("clicked upload button")
    var uploadPanel = $('.upload-panel');
    uploadPanel.slideUp(1000);
    $('#second-page').animate({'margin-top': '0px'}, 1000);
    $('#upload-panel-button').css({display : "block"});
  });

});


