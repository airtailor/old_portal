$(document).on("click", "#november-button", function(){
  $(".burb-dashboard-button").css('color', 'blue');
  $(".stuff").hide();
  $(".november-stuff").show();
  $("#november-button").css('color', 'red');
});

$(document).on("click", "#december-button", function(){
  $(".burb-dashboard-button").css('color', 'blue');
  $(".stuff").hide();
  $(".december-stuff").show();
  $("#december-button").css('color', 'red');
});

$(document).on("click", "#january-button", function(){
  $(".burb-dashboard-button").css('color', 'blue');
  $(".stuff").hide();
  $(".january-stuff").show();
  $("#january-button").css('color', 'red');
});

$(document).on("click", "#february-button", function(){
  $(".burb-dashboard-button").css('color', 'blue');
  $(".stuff").hide();
  $(".february-stuff").show();
  $("#february-button").css('color', 'red');
});

$(document).on("click", "#invoice-1", function(){
  $("#invoice-1-details").slideToggle()
});

$(document).on("click", "#invoice-2", function(){
  $("#invoice-2-details").slideToggle()
});

$(document).on("click", "#invoice-3", function(){
  $("#invoice-3-details").slideToggle()
});

$(document).on("click", "#invoice-5", function(){
  $("#invoice-6-details").slideToggle()
});

$(document).on("click", "#invoice-6", function(){
  $("#invoice-6-details").slideToggle()
});

$(document).on("click", "#invoice-7", function(){
  $("#invoice-6-details").slideToggle()
});
