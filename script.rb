require 'pry'
require 'active_support'
require 'pg'

class DataExtractor
  attr_accessor :orders, :customers, :shipments, :measurements
  def initialize
    get_customers
    remove_customers_without_phones
    format_customers
    remove_dummy_customers
    remove_duplicate_customers

    get_orders
    dismiss_old_incomplete_orders
    remove_orders_without_last_name
    remove_orders_with_dummy_tailor
    remove_dummy_orders

    @shipments = []
    get_shipments_from_orders

    set_order_type
    format_welcome_kits
    connect_orders_to_tailors
    format_orders
    update_order_notes_with_previous_id

    @measurements = []
    get_measurements
    format_measurements

    #connect_orders_to_tailors
  end

  def connect_orders_to_tailors
    # user ids
    # 7 - HB Alterations - new id = 6
    # 11 - Tailoring NYC - new id = 4
    # 2 - Tower Cleaners - new id = 8
    # 9 - Vaneyde Tailoring - new id = 7
    # 12 - Lucky Tailors - new id = 9

    @orders.map do |order|
      replace_key(order, "user_id", "provider_id")
      update(order, "provider_id", get_new_tailor_id(order["provider_id"]))
    end
  end

  def get_new_tailor_id old_id
    case old_id
    when 7
      new_id = 6
    when 11
      new_id = 4
    when 2
      new_id = 8
    when 9
      new_id = 7
    when 12
      new_id = 9
    when 1
      new_id = 1
    end
    new_id
  end

  def get_measurements
    @measurements = Measurement.all.as_json.select do |measurement|
      measurement["customer_name"].split(" ").length > 1 ?
        true :
        false
    end
  end

  def format_measurements
    @measurements = @measurements.map do |measurement|
      remove(measurement, "customer_id")
      remove(measurement, "id")
    end
  end

  def make_shipment(order, type)
    shipment = {
      tracking_number: order["tracking_number"] || order[:tracking_number] || "",
      shipping_label: order["shipping_label"],
      type: type,
      weight: order["weight"],
      order_id: order["id"]
    }
    @shipments.push(shipment)
  end

  def get_shipments_from_orders
    last_500_orders = @orders.sort_by {|x| x["created_at"]}.last(500)
    last_500_orders.each do |order|
      outgoing_shipment = order["shipping_label"] && !order["shipping_label"].empty?
      incoming_shipment = order["inbound_label"] && !order["inbound_label"].empty?

      if !outgoing_shipment && incoming_shipment
        shipment =  make_shipment(order, "IncomingShipment")
        order["inbound_label"] && !order["inbound_label"].empty?
      elsif order["shipping_label"] && !order["shipping_label"].empty?
        shipment = make_shipment(order, "OutgoingShipment")
      end
    end
  end

  def capitalize_name name
    name.split(" ").map(&:capitalize).join(" ")
  end

  def format_customers
    @customers = @customers.map do |customer|
      customer["street1"] = customer.delete("address1")
      customer["street2"] = customer.delete("address2")

      # capitalize all words in name
      update(customer, "first_name", capitalize_name(customer["first_name"]))
      update(customer, "last_name", capitalize_name(customer["last_name"]))

      # remove spaces from first name
      if customer["first_name"][-1] == " "
        new_first_name = customer["first_name"].split("").select{|x| !x.blank?}.join
        update(customer, "first_name", new_first_name)
      end

      first_name_split = customer["first_name"].split(" ")
      last_name_split = customer["last_name"].split(" ")

      # remove commas from last names
      customer["last_name"] = customer["last_name"].gsub(",", "")

      # remove suffixes
      suffix = ""
      suffixes = ["Jr", "JR", "jr", "SR", "Sr", "sr"]

      if suffixes.include? last_name_split[-1].gsub(/[^a-z]/i, '')
        suffix = " #{last_name_split.pop}"
        no_suffix = customer["last_name"].split.reject{|x|x == suffix}.first
        update(customer, "last_name", no_suffix)
      end

      # # get rid of long middle names


      # if first_name_split.length > 1
      #   first_name = first_name_split[0]
      #   abreviation = first_name_split[1].gsub(/[^a-z]/i, '')
      #   middle_name = ""

      #   if abreviation.length > 1
      #     if abreviation.length > 3
      #       middle_name = ""
      #     else
      #       middle_name = "#{first_name_split[1]} "
      #     end
      #   else
      #     middle_name = ""
      #   end

      #   last_name = ""

        # get rid of middle names always


      if first_name_split.length > 1
        first_name = first_name_split[0]
        # abreviation = first_name_split[1].gsub(/[^a-z]/i, '')
        # middle_name = ""
        update(customer, "first_name", first_name)
      end

        last_name = ""


      if last_name_split.length > 1
        last_name = "#{last_name_split[-1]}#{suffix}"
        update(customer, "last_name", last_name)
      else
        last_name = "#{customer["last_name"]}#{suffix}"
        update(customer, "last_name", last_name)
      end


      if customer["first_name"] == "Daniel" && customer["last_name"] == "Avalos Ruiz"
        update(customer, "last_name", "Ruiz")
      end

      if customer["first_name"] == "Mor" && customer["last_name"] == "Fleisher Leach"
        update(customer, "last_name", "Leach")
      end

      #puts customer["first_name"] + " " + customer["last_name"]
      #byebug if customer["last_name"] == "De Anda"
      #yebug if customer["first_name"].include? "Laura"

      if customer["last_name"] == "Alaniz-3155"
        update(customer, "last_name", "Alaniz")
      end

      remove(customer, "unique_id")
      remove(customer, "company")
      remove(customer, "order_id")
      remove(customer, "measurements")
      update(customer, 'phone', customer["phone"].scan(/\d/).join)

      if customer["last_name"].include?("Amberths")
          update(customer, "first_name", "Luis")
          update(customer, "last_name", "Amberths")
        elsif customer["last_name"].include?("Desena Jr")
          update(customer, "first_name", "Roberto")
          update(customer, "last_name", "Desena Jr")
        elsif customer["last_name"].include?("Flippin")
          update(customer, "first_name", "Richard")
          update(customer, "last_name", "Flippin")
        end

      update(customer, "shopify_id", customer["shopify_id"].to_s)
    end
  end

  def dismiss_old_incomplete_orders
    @orders = @orders.map do |order|
      add(order, "dismissed", false)
      if !order["complete"]
        if order["created_at"] < 45.days.ago
          update(order, "dismissed", true)
        end
      end
      order
    end
  end

  def format_welcome_kits
    @orders = @orders.map do |order|
      type = order["type"]
      alterations = order["alterations"]
      if (type  == "WelcomeKit" || alterations.include?("Welcome Kit"))
        if alterations.length > 103
          puts eval(alterations)
          alterations = eval(alterations).except!("Air Tailor Welcome Kit ")
          update(order, "alterations", alterations)
          byebug
          update(order, "type", "TailorOrder")
        end
      end
      order
    end
  end

  def remove_orders_without_last_name
    @orders = @orders.select do |order|
      order["name"].split(" ").count > 1
    end
  end

  def remove_orders_with_dummy_tailor
    @orders = @orders.reject do |order|
      dummy_ids = [3, 5, 6, 10]
      dummy_ids.include?(order["user_id"])
    end
  end

  def remove_duplicate_customers
    # list of customers removed because of not unique phone number or shopify id or email
    # Julio Novo
    # Julio Novo
    # Tyler Armstrong
    # Dave Lucas
    # Brent Gunsalus
    # John Crager
    # Leo Weiss
    # Erica Rau
    # Neil Wyman
    # Jeff Lawson
    # Kevin Shirley
    # Daniel Avalos Ruiz
    # Patricia Bergwerk
    # Ty Wilson
    # Tyler Walrath
    # Elizabeth Colangelo
    # Katherine Dold
    # Jesse Morgans
    # Vlad Vukicevic
    # Manini Gupta
    # Ruth Kett
    # Lorenzo Walker
    # Michelle Bao
    # Meharvan Singh
    # Benjamin Fels
    # Aaron Baker
    # Brian Miller
    # Harrison Jobe
    # Alicia Lagala
    # Jeannie Delgado
    # Chad Simpson
    # Renita Lovell
    # Stacey Scholl
    # Mio Magee
    # Laura De Anda
    # Douglas Smith
    # Adam Pasternak
    # Brian Rue
    # Manini Gupta
    # Alex Mondre
    # Kelly Ruggiero
    # Mio Magee
    # Thomas Hope
    # Michelle Bao
    # Preston Volman
    # Darnell Terry
    # Adam Pasternak
    # Renita Lovell
    # Stacey Scholl
    # Darnell Terry
    # Ryan Lenet
    # Michelle Bao
    # Seth Sutton
    # Darnell Terry
    # Kayla Vines
    # Michael Geller
    # Andres Gantous
    # James Morales
    # James Morales
    # Richard Swersky
    # Renita Lovell
    # Xinlu Liu
    # Angel L Reyes Rodriguez
    # Ty Wilson
    # Cotton Bryan
    # Theodore Scholtz
    # Seth Sutton
    # Renita Lovell
    # Tim Maxwell
    # Nick Clayton
    # Jonah Kaplan
    # Ryan Broshar
    # Anna Araza
    # Bramdon Hughes
    # Bramdon Hughes
    # Steven Major
    # Richard Ham
    @customers = @customers.uniq {|x| x["phone"]}
    @customers = @customers.uniq {|x| x["shopify_id"]}
    @customers = @customers.uniq {|x| x["email"]}
  end

  def remove_dummy_orders
    @orders = @orders.reject do |order|
      (
        order["name"] == "Ariel Avila" ||
        order["name"] == "Joshua Brueckner" ||
        order["name"] == "Brian Flynn" ||
        order["name"] == "Sam Tilin" ||
        order["name"] == "Kyong Shik Choo" ||
        order["name"] == "John Lesley Morton" ||
        order["name"] == "Joseph Reed" ||
        order["name"] == "Eric Hall" ||
        order["name"] == "Ian Benjamin" || # tie slimming service
        order["name"] == "John Kelly  jr" ||
        order["name"] == "John" ||
        order["name"] == "Fon N"
      )
    end
  end

  def set_order_type
    @orders = @orders.map do |order|
      if order["welcome"]
        add(order, "type", "WelcomeKit")
      else
        if order["alterations"].include? "WelcomeKit"
          add(order, "type", "WelcomeKit")
          puts order["alterations"]
          byebug
        else
          add(order, "type", "TailorOrder")
        end
      end
      order
    end
  end

  def remove_customers_without_phones
    @customers = @customers.reject do |customer|
      customer["phone"] == "" || customer["phone"] == nil
    end
  end

  def remove_dummy_customers
    @customers = @customers.reject do |customer|
      nums = ["1231231234", "16167804457", "6302352544", "0000000000"]
      nums.include?(customer["phone"])
    end
  end

  def format_orders
    @orders = @orders.map do |order|
      # byebug if order["id"] == 1901

      remove(order, "tie_amount")
      remove(order, "error_message")
      remove(order, "counter")
      remove(order, "conversation")
      remove(order, "shipping_label")
      remove(order, "inbound_label")
      remove(order, "tracking_number")
      remove(order, "inbound_counter")
      remove(order, "welcome")
      remove(order, "unique_id")
      remove(order, "tracker")
      remove(order, "shipping_label")
      remove(order, "inbound_label")
      remove(order, "customer_id")

      replace_key(order, "complete", "fulfilled")
      replace_key(order, "tailor_notes", "provider_notes")
      replace_key(order, "note", "requester_notes")

      add(order, "source", "Shopify")
      update(order, "shopify_id", order["shopify_id"].split("#").second)

      update(order, "name", capitalize_name(order["name"]))
      replace_key(order, "shopify_id", "source_order_id")
      replace_key(order, "fulfill_date", "fulfilled_date")

      if order["name"] == "Jeremiah Novella Jeremiah Buenafe" || order["name"] == "Jeremiah Buenafe"
        update(order, "name", "Jeremiah Novella Buenafe")
      end

      if order["name"] == "Diego Alaniz-3155"
        update(order, "name", "Diego Alaniz")
      end

      # capitalize name
      update(order, "name", capitalize_name(order["name"]))

      # remove commas from  name
      update(order, "name", order["name"].gsub(",", ""))

      split_name = order["name"].split(" ")

      # remove Dr
      if split_name.first == "Dr."
        doc, *no_doc = split_name
        split_name = no_doc
        update(order, "name", no_doc.join(" "))
      end

      byebug if order["name"].include? "Dr."

      # remove suffixes
      suffix = ""
      suffixes = ["Jr", "JR", "jr", "SR", "Sr", "sr"]

      if suffixes.include? split_name[-1].gsub(/[^a-z]/i, '')
        suffix = " #{split_name.pop}"
        no_suffix = split_name.reject{|x|x == suffix}.join(" ")
        update(order, "name", no_suffix)
      end

      first_name = order["name"].split(" ")[0]
      last_name = "#{order["name"].split(" ")[-1]}#{suffix}"
      new_name = "#{first_name} #{last_name}"


      customers = @customers.select{|x| x["first_name"] == first_name && x["last_name"] == last_name}

      # if order["name"] == "Laura De Anda"
      #   customers = @customers.select{|x| x["first_name"] == "Laura" && x["last_name"] == "De Anda"}
      # end

      if !customers.empty?
        new_name = new_name + suffix
        update(order, "name", new_name)
     else
       puts order["name"]
     end

      # if suffixes.include? split_name[-1].gsub(/[^a-z]/i, '')

      # end

      #byebug if order["name"].include? "Desena"
      # remove abbreviations


      remove(order, "tracking_number")
      order
    end
  end


  def update_order_notes_with_previous_id
    @orders = @orders.map do |order|
      notes = order["requester_notes"]
      id = order["source_order_id"]
      id_note = "PREVIOUS ORDER ID: #{id}"
      new_notes = notes.blank? ? id_note : "#{notes} || #{id_note}"
      puts "order #{order["id"]} id_note#{id_note}"
      update(order, "requester_notes", new_notes)
    end
  end

  private

  def replace_key hash, old_key, new_key
    hash[new_key] = hash.delete(old_key)
    hash
  end

  def remove hash, key
    hash.delete(key)
    hash
  end

  def update hash, key, value
    hash[key] = value
    hash
  end

  def add hash, key, value
    hash[key] = value
    hash
  end

  def get_customers
    @customers = Customer.all.map do |customer|
      measurements_hash = customer.measurements.as_json
      cust_hash = customer.as_json
      cust_hash['measurements'] = measurements_hash
      cust_hash
    end
  end

  def get_orders
    @orders = Order.all
    @orders = @orders.reject {|x| x.name == "John"}
    @orders = @orders.map do |order|
      if order["welcome"]
        order = update(order, "alterations", []).as_json
      else
        order = format_alterations(order).as_json
      end
      order = stringify_timestamps(order).as_json
    end.sort_by{|order| order["created_at"]}
  end

  def stringify_timestamps(hash)
    hash['created_at'].to_s
    hash['updated_at'].to_s
    hash
  end

  def remove_dummy_item alterations
    dummies = [
      "Shirt #1 Shirt", "Shirt #2 Shirt", "Shirt #3 Shirt", "Shirt #4 Shirt", "Shirt #5 Shirt", "Shirt #6 Shirt",
      "Pants #1 Pants", "Pants #2 Pants", "Pants #3 Pants", "Pants #4 Pants", "Pants #5 Pants", "Pants #6 Pants",
      "Skirt #1 Skirt", "Skirt #2 Skirt", "Skirt #3 Skirt", "Skirt #4 Skirt", "Skirt #5 Skirt", "Skirt #6 Skirt",
      "Dress #1 Dress", "Dress #2 Dress", "Dress #3 Dress", "Dress #4 Dress", "Dress #5 Dress", "Dress #6 Dress"]

    alterations.reject do  |alt|
      #puts alt
      #byebug if dummies.include? alt#alt.include?("Pants") && !alt.include?("Pants #1") && !alt.include?("Pants #2")
      dummies.include? alt
    end
  end

  def remove_welcome_kit alterations
    alterations.reject do |key, value|
      key == "Air Tailor Welcome Kit "
    end
  end

  # finish handling ties
  def format_alterations(order)
    order_alts = JSON.parse(order["alterations"])
    order_alts = remove_dummy_item(order_alts)
    order_alts = remove_welcome_kit(order_alts) if order_alts != ["Air Tailor Welcome Kit "]

    alt_hash = order_alts.each_with_object({}) do |curr, prev|
      if curr.split(" ")[0].include? "Tie"

        if !prev.blank?
          tie_count = prev.keys.inject(0) do |total, new|
           total += new.scan(/(?=Tie)/).count
          end
        else
          tie_count = 0
        end

        key = "Tie ##{tie_count + 1}"
        type = "Tie"
        alteration = curr.split(/(\d+)/).join

      else
        key = curr.split(/(?<=\d) /)[0] # example: Shirt #1
        type = curr.split(/ #\d/)[0] # example: Shirt
        alteration = curr.split(/\d /)[1] # example: Add Collar Buttons
      end

      binding.pry if curr.include? "Gift Card"

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

# class DataInserter
#   attr_accessor :orders, :customers, :shipments, :measurements

#   def initialize(data)
#     byebug
#     @orders = data["orders"]
#   #   @customers = data["customers"]
#   #   @shipments = data["shipments"]
#   #   @measurements = data["measurements"]
#   end



# end

data = DataExtractor.new

data.customers.each do |cust|
  #puts "#{cust['first_name']} #{cust['last_name']}"
end

binding.pry

# require 'FileUtils'
require 'json'
FILE_PATH = "orders.rb"

FileUtils.rm(FILE_PATH)

File.open(FILE_PATH, "w+") do |f|
  f << data.to_json
end
