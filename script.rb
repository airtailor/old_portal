# Order.all.each do |order|
#   puts "order #{order.id}"
# end

# Customer.all.each do |customer|
#   puts "customer #{customer.id}"
# end
require "pry"
# x = Order.first
# binding.pry

require 'csv'
# binding.pry
# CSV.open("orders.csv", "wb") do |csv|
#   csv << Order.attribute_names
#   Order.all.each do |order|
#     csv << order.attributes.values
#   end
# end

x = JSON.parse(Order.first.alterations)
alt_list = x.inject({}) do |prev, curr|
  key = curr.split(/(?<=\d) /)[0] # example: Shirt #1
  type = curr.split(/ #\d/)[0] # example: Shirt
  alteration = curr.split(/\d /)[1] # example: Add Collar Buttons

  if prev[key]
    prev[key][:alterations].push({variant_title: alteration})
  else
    hash = {title: type, alterations: [{variant_title: alteration}]}
    prev[key] = hash
  end

  prev
end

puts alt_list

# collapsed_list =
