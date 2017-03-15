$(document).on("click", "#date-submit", function(){
  var date = $("#date-input").val()
  $("#date-output").html('<% @orders.each do |order| %><% if order.created_at > Date.parse(' + date + ') %>poop<% end %><br><% end %>')
})
