require 'pry'
require 'active_support'

class DataExtractor
  attr_accessor :orders, :customers
  def initialize
    get_customers
    get_orders
  end

  def reformat_customers
    @customers = @customers.map do |customer|
      customer["street1"] = customer.delete("address1")
      customer["street2"] = customer.delete("address2")
      customer.delete("unique_id")
      customer
    end
  end

  def dismiss_old_incomplete_orders
    @orders = @orders.map do |order|
      if !order["complete"]
        if order["created_at"] < 45.days.ago
          order["dismissed"] = true
        end
      end
      order
    end
  end

  def format_orders
    @orders = @orders.map do |order|
      remove(order, "tie_amount")
      remove(order, "error_message")
      remove(order, "counter")
      remove(order, "conversation")
      # remove(order, "unique_id") ? ? ? 

      # change note to requester_notes
      # change
      # change complete to fulfilled
      # change fulfill_date to fulfilled_date
      #
      # add provider_notes
      #
      # make turn into welcome kits or tailor orders
      #
      #
      
      order = remove(order, "tracker")
      #order = remove(order, "tracking_number")
    end
  end


  def make_shipments
  end




#  def format_orders
#  end

#  def add_fulfilled
#  end

#  def remove_complete
#  end

#  def rename_notes
#  end

  
  def remove_error_messages
  end


  def update_order_notes
  end

  private

  def replace_key hash, old_key, new_key
    hash[new_key] = hash.delete(old_key)
  end

  def remove hash, key
    hash.delete(key)
    hash
  end

  def update hash, key, value
  end

  def add hash, key, value
  end

  def get_customers
    @customers = Customer.first(50).map do |customer|
      measurements_hash = customer.measurements.as_json
      cust_hash = customer.as_json
      cust_hash['measurements'] = measurements_hash
      cust_hash
    end
  end

  def get_orders
    @orders = Order.first(50).map do |order|
      order = format_alterations(order).as_json
      order = stringify_timestamps order
    end
  end

  def stringify_timestamps(hash)
    hash['created_at'].to_s
    hash['updated_at'].to_s
    hash
  end

  def format_alterations(order)
    order_alts = JSON.parse(order.alterations)

    alt_hash = order_alts.each_with_object({}) do |curr, prev|
      key = curr.split(/(?<=\d) /)[0] # example: Shirt #1
      type = curr.split(/ #\d/)[0] # example: Shirt
      alteration = curr.split(/\d /)[1] # example: Add Collar Buttons

      binding.pry if curr == "Gift Card "
      console.log(key)

      if prev[key]
        prev[key][:alterations].push(variant_title: alteration)
      else
        hash = { title: type, alterations: [{ variant_title: alteration }] }
        prev[key] = hash
      end
    end

    order['alterations'] = alt_hash
    order
  end
end

data = DataExtractor.new
data.reformat_customers
data.dismiss_old_incomplete_orders
binding.pry

# data.get_customers
# puts data.customers
# puts "\n"
# data.get_orders
# puts data.orders

# write array of hashes to a ruby file
# File.write('orders.rb', "require 'active_support/all'\norders=#{orders}")
# orders = nil

# require_relative 'orders.rb'
