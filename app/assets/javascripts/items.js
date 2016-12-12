// console.log("ready")

// $("#measurements-back").click(function(){
//   console.log("click")
//   $("#clothes-front").fadeOut('slow');
//   $("#clothes-back").fadeIn("slow");
// });

var x = 1;
console.log(x)

  $(document).on("click", "#measurements-back", function(){
    x = 2
    console.log(x)
    $("input.clothes-front").css('opacity', '0');
    $("input.clothes-back").css('opacity', '0');
    $("#clothes-front-image").css('opacity', '0');
    $("div.clothes-front").css('opacity', '0');
    $("#clothes-back-image").css('opacity', '1')
    $("div.clothes-back").css('opacity', '1');
    $("#measurements-save").hide()
    $("#measurements-edit").show()
  });

  $(document).on("click", "#measurements-front", function(){
    x = 1
    console.log(x)
    $("input.clothes-back").css('opacity', '0');
    $("input.clothes-front").css('opacity', '0');
    $("#clothes-front-image").css('opacity', '1');
    $("div.clothes-front").css('opacity', '1');
    $("#clothes-back-image").css('opacity', '0');
    $("div.clothes-back").css('opacity', '0');
    $("#measurements-save").hide()
    $("#measurements-edit").show()
  });


  $(document).on("click", "#measurements-edit", function(){
    console.log(x)
    if(x===1){
      $("div.clothes-back").css('opacity', '0');
      $("input.clothes-back").css('opacity', '0');
      $("div.clothes-front").css('opacity', '0');
      $("input.clothes-front").css('opacity', '1');
      $("#measurements-edit").hide();
      $("#measurements-save").show();
    } else if (x===2) {
      $("div.clothes-front").css('opacity', '0');
      $("input.clothes-front").css('opacity', '0');
      $("div.clothes-back").css('opacity', '0');
      $("input.clothes-back").css('opacity', '1');
      $("#measurements-save").css('opacity', '1');
      $("#measurements-edit").hide();
      $("#measurements-save").show();
    }
  });

  $(document).on("click", "#measurements-save", function(){
      $("#measurements-save").hide()
      $("#measurements-edit").show()
  });


$(document).on("click", "#packing-slip-btn", function() {
  $('#packing-slip-info').printThis({
    removeInline: true
  });
});

$(document).on("click", "#print-instructions", function() {
  $('#item-alteration-lists').printThis({
    removeInline: true
  })
});

// $(document).on("click", "#print-instructions", function() {
//   $('#item-alteration-lists').printThis({
//     removeInline: true
//   })
// });

$(document).on("click", "#add-notes", function() {
  $('#tailor-notes-form').show();
});

$(document).on("click", "#save-notes", function() {
  $('#tailor-notes-form').hide();
});

$(document).ready(function(){
  setTimeout(function(){
    $('.alert').remove();
  }, 3000);
 })




