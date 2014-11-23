$(function() {

  // second page should be invisible at the beginning
  // $('#second-page').css({display : "none"});
 $('#right-panel-register').css({display : "none"});

  // clicking on the arrow makes the side panel visible
  // $('#right-panel-link').on('click', function(){
  //   console.log("clicked the arrow");
  // });
  $('#right-panel-link').panelslider({side: 'right', clickClose: false, duration: 500 });


  //clicking on register in the side panel shows the registration form
  // and makes the login form disappear
  $('#register').on('click', function(){
    $('#register-button').hide();
    $('#right-panel-login').css({display : "none"});
  })


  // // SECOND PAGE
  // //clicking on the loggin button makes the second page visible
  $('#login-button').click(function() {
    $.panelslider.close();
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

  
});


