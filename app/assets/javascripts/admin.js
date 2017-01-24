$(document).on("click", "#this-week-button", function(){
      $(".dashboard-button").css('color', 'blue');
      $("#this-week").show()
      $("#last-week").hide()
      $("#this-month").hide()
      $("#last-month").hide()
      $("#this-week-button").css('color', 'red');
  });

$(document).on("click", "#last-week-button", function(){
      $(".dashboard-button").css('color', 'blue');
      $("#last-week").show()
      $("#this-week").hide()
      $("#this-month").hide()
      $("#last-month").hide()
      $("#last-week-button").css('color', 'red');
  });

$(document).on("click", "#this-month-button", function(){
      $(".dashboard-button").css('color', 'blue');
      $("#this-month").show()
      $("#last-month").hide()
      $("#this-week").hide()
      $("#last-week").hide()
      $("#this-month-button").css('color', 'red');
  });

$(document).on("click", "#last-month-button", function(){
      $(".dashboard-button").css('color', 'blue');
      $("#last-month").show()
      $("#this-month").hide()
      $("#this-week").hide()
      $("#last-week").hide()
      $("#last-month-button").css('color', 'red');
  });

$(document).on("click", "#all-button", function(){
      $(".dashboard-button").css('color', 'blue');
      $(".dashboard-row").show()
      $("#all-button").css('color', 'red');
  });



