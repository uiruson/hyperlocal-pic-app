

// See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

$(document).ready(function(){

  // second page should be invisible at the beginning
  $('#second-page').css({display : "none"});

  // login/register panel invisible at the beginning
  $('#right-panel-register').css({display : "none"});

  // clicking on the arrow makes the side panel visible
  $('#right-panel-link').panelslider({side: 'right', clickClose: false, duration: 200 });

  //clicking on register in the side panel shows the registration form
  // and makes the login form disappear
  $('#register').on('click', function(){
    $(this).css({display : "none"});
    $('#right-panel-login').css({display : "none"});
    $('#right-panel-register').css({display : "block"});
  })


  // SECOND PAGE
  //clicking on the loggin button makes the second page visible
  $('#login-button').on('click', function(){
    console.log("clicked login")
    $('#first-page').css({display : "none"});
    $('#second-page').css({display : "block"});
  });

  //sliding panel to upload pictures
  $('.pull-me').click(function() {
        $('.upload-panel').slideToggle('slow');
    });
});


