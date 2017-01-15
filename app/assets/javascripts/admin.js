

$(document).on("click", "#this-month-button", function(){
      $("#this-month").show()
      $("#last-month").hide()
  });

$(document).on("click", "#last-month-button", function(){
      $("#this-month").hide()
      $("#last-month").show()
  });

$(document).on("click", "#all-button", function(){
      $(".dashboard-row").show()
  });
