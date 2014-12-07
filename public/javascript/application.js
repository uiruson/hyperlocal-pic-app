$(function() {

  var pathname = window.location.pathname;
  var imgId;

  if (pathname.indexOf("/instagram_images/") >= 0){
    imgId = pathname.replace('/instagram_images/','');
    $('#userImg-'+imgId+' img').css('background-color','#fee268');
  }
 
  $('#right-panel-register').css({display : "none"});
  $('#backto-login-button').hide();
  $('#right-panel-link').panelslider({side: 'right', clickClose: false, duration: 500 });

  $('#register').on('click', function(){
    $('#right-panel-login').css({display : "none"});
    $('#right-panel-register').css({display : "block"});
    $('#register-button').hide();
    $('#backto-login-button').show();
  });

  $('#backToLogin').on('click', function(){
    $('#right-panel-login').css({display : "block"});
    $('#right-panel-register').css({display : "none"});
    $('#backto-login-button').hide();
    $('#register-button').show();
  });

  $('#upload-panel-button').on('click', function(){
     var uploadPanel = $('.upload-panel');
     if (uploadPanel.is(':hidden')) {
      var height = $('.upload-panel').outerHeight(true);
      $('#second-page').animate({'margin-top': height+'px'}, 00);
      uploadPanel.slideDown(800);
      $(this).css({display : "none"})

     }
  });

  $('#upload-picture').on('click', function(){
    console.log("clicked upload button")
    var uploadPanel = $('.upload-panel');
    uploadPanel.slideUp(1000);
    $('#second-page').animate({'margin-top': '0px'}, 1000);
    $('#upload-panel-button').css({display : "block"});
  });

  $('#cancel-upload').on('click', function(){
    console.log("clicked upload button")
    var uploadPanel = $('.upload-panel');
    uploadPanel.slideUp(1000);
    $('#second-page').animate({'margin-top': '0px'}, 1000);
    $('#upload-panel-button').css({display : "block"});
  });
});