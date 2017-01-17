$(document).on("click", "#this-week-button", function(){
      $("#this-week").show()
      $("#this-month").hide()
      $("#last-month").hide()

  });

$(document).on("click", "#this-month-button", function(){
      $("#this-month").show()
      $("#last-month").hide()
      $("#this-week").hide()
  });

$(document).on("click", "#last-month-button", function(){
      $("#last-month").show()
      $("#this-month").hide()
      $("#this-week").hide()
  });

$(document).on("click", "#all-button", function(){
      $(".dashboard-row").show()
  });
