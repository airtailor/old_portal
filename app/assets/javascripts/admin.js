$(document).on("click", "#this-week-button", function(){
      $("#this-week").show()
      $("#last-week").hide()
      $("#this-month").hide()
      $("#last-month").hide()
      $("#this-week-button").toggleClass('.active-dashboard');
  });

$(document).on("click", "#last-week-button", function(){
      $("#last-week").show()
      $("#this-week").hide()
      $("#this-month").hide()
      $("#last-month").hide()
  });

$(document).on("click", "#this-month-button", function(){
      $("#this-month").show()
      $("#last-month").hide()
      $("#this-week").hide()
      $("#last-week").hide()
  });

$(document).on("click", "#last-month-button", function(){
      $("#last-month").show()
      $("#this-month").hide()
      $("#this-week").hide()
      $("#last-week").hide()
  });

$(document).on("click", "#all-button", function(){
      $(".dashboard-row").show()
  });
