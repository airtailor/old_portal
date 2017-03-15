$(document).on("click", "#november-button", function(){
  $(".burb-dashboard-button").css('color', 'slategray');
  $(".stuff").hide();
  $(".november-stuff").show();
  $("#november-button").css('color', 'red');
  $("#dash-month-name").html("Nov. 2016");
});

$(document).on("click", "#december-button", function(){
  $(".burb-dashboard-button").css('color', 'slategray');
  $(".stuff").hide();
  $(".december-stuff").show();
  $("#december-button").css('color', 'red');
  $("#dash-month-name").html("Dec. 2016");
});

$(document).on("click", "#january-button", function(){
  $(".burb-dashboard-button").css('color', 'slategray');
  $(".stuff").hide();
  $(".january-stuff").show();
  $("#january-button").css('color', 'red');
  $("#dash-month-name").html("Jan. 2017");
});

$(document).on("click", "#february-button", function(){
  $(".burb-dashboard-button").css('color', 'slategray');
  $(".stuff").hide();
  $(".february-stuff").show();
  $("#february-button").css('color', 'red');
  $("#dash-month-name").html("Feb. 2017");
});

$(document).on("click", "#invoice-1", function(){
  $("#invoice-1").toggleClass('blueback');
  $("#invoice-1-details").slideToggle()
});

$(document).on("click", "#invoice-2", function(){
  $("#invoice-2").toggleClass('blueback');
  $("#invoice-2-details").slideToggle()
});

$(document).on("click", "#invoice-3", function(){
  $("#invoice-3").toggleClass('blueback');
  $("#invoice-3-details").slideToggle()
});

$(document).on("click", "#invoice-5", function(){
  $("#invoice-5").toggleClass('blueback');
  $("#invoice-5-details").slideToggle()
});

$(document).on("click", "#invoice-6", function(){
  $("#invoice-6").toggleClass('blueback');
  $("#invoice-6-details").slideToggle()
});

$(document).on("click", "#invoice-7", function(){
  $("#invoice-7").toggleClass('blueback');
  $("#invoice-7-details").slideToggle()
});

$(document).on("click", "#invoice-calendar", function(){
  $("#invoice-choose-date").fadeToggle()
  $("#choose-date-content").fadeToggle()
})

$(document).on("mouseleave", "#choose-date-content", function() {
  $("#choose-date-content").fadeToggle()
  $("#invoice-choose-date").fadeToggle()

});

$(document).on("click", "#download-invoice", function() {
  $('#invoice-print-area').printThis({
    removeInline: true
  })
});
