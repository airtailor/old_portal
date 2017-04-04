require 'shippo'
require 'shippo/api/category'
require 'shippo/exceptions/api_error'
require 'json'
require 'pdfkit'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def saveShippingInfo(order, customer)

    Shippo::api_token = ENV["SHIPPO_KEY"]

    address_from = {
     :object_purpose => 'PURCHASE',
      :name => 'Air Tailor',
      :company => 'Air Tailor',
      :street1 => '510 West 21st Street',
      :street2 => '65DM8A',
      :city => 'New York',
      :state => 'NY',
      :zip => '10011',
      :country => 'US',
      :phone => '+1 555 341 9393',
      :email => 'orders@airtailor.com'
    }

    first = customer[:first_name]
    last = customer[:last_name]
    customer_name = first + " " + last

    address_to = {
      :object_purpose => 'PURCHASE',
      :name => customer_name,
      :company => customer[:company],
      :street1 => customer[:address1],
      :street2 => customer[:address2],
      :city => customer[:city],
      :state => customer[:state],
      :zip => customer[:zip],
      :country => 'US',
      :phone => customer[:phone],
      :email => customer[:email]
    }

    parcel = {
      :length => 7,
      :width => 5,
      :height => 3,
      :distance_unit => :in,
      :weight => order[:weight],
      :mass_unit => :g
    }

    shipment = {
      :object_purpose => 'PURCHASE',
      :address_from => address_from,
      :address_to => address_to,
      :parcel => parcel
    }

    shipment = {
      :shopify_id => order[:shopify_id],
      :shipment => shipment
    }

    Shipment.new(shipment).save
  end


  def tailorShippingInfo(user, order, customer)
    Shippo::api_token = ENV["SHIPPO_KEY"]

    customer_name = customer.first_name + " " + customer.last_name

    address_from = {
      :object_purpose => 'PURCHASE',
      :name => customer_name,
      :company => customer.company,
      :street1 => customer.address1,
      :street2 => customer.address2,
      :city => customer.city,
      :state => customer.state,
      :zip => customer.zip,
      :country => "US",
      :phone => customer.phone,
      :email => customer.email
    }

    address_to = {
      :object_purpose => "PURCHASE",
      :name => "Air Tailor",
      :company => "",
      :street1 => user.street,
      :street2 => user.unit,
      :city => user.city,
      :state => user.state,
      :zip => user.zip,
      :country => "US",
      :phone => user.phone,
      :email => user.email
    }

    if address_to[:state] == "Washington DC"
      address_to[:state] = "DC"
    end

    if address_from[:state] == "Washington DC"
      address_from[:state] = "DC"
    end

    parcel = {
        :length => 7,
        :width => 5,
        :height => 3,
        :distance_unit => :in,
        :weight => order.weight,
        :mass_unit => :g
    }

    shipment = {
        :object_purpose => 'PURCHASE',
        :address_from => address_from,
        :address_to => address_to,
        :parcel => parcel
    }

    if order.weight.to_i < 452
      transaction = Shippo::Transaction.create(
          :shipment => shipment,
          :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
          :servicelevel_token => "usps_first",
          :label_file_type => "PNG"
      )
    else
      transaction = Shippo::Transaction.create(
          :shipment => shipment,
          :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
          :servicelevel_token => "usps_priority",
          :label_file_type => "PNG"
      )
    end

    # binding.pry
    if transaction.object_state == "INVALID"
      order.update_attribute(:error_message, transaction.messages[0].text)
    end

    order.update_attribute(:inbound_label, transaction.label_url)
    order.update_attribute(:tracker, transaction.tracking_url_provider)



  end

  def kitShippingInfo(user, order, customer)
    Shippo::api_token = ENV["SHIPPO_KEY"]

    order.update_attribute(:counter, 2)

    customer_name = customer.first_name + " " + customer.last_name

    address_from = {
      :object_purpose => 'PURCHASE',
      :name => customer_name,
      :company => customer.company,
      :street1 => customer.address1,
      :street2 => customer.address2,
      :city => customer.city,
      :state => customer.state,
      :zip => customer.zip,
      :country => "US",
      :phone => customer.phone,
      :email => customer.email
    }

    address_to = {
      :object_purpose => "PURCHASE",
      :name => "Air Tailor",
      :company => "",
      :street1 => user.street,
      :street2 => user.unit,
      :city => user.city,
      :state => user.state,
      :zip => user.zip,
      :country => "US",
      :phone => user.phone,
      :email => user.email
    }

    if address_to[:state] == "Washington DC"
      address_to[:state] = "DC"
    end

    if address_from[:state] == "Washington DC"
      address_from[:state] = "DC"
    end

    parcel = {
        :length => 7,
        :width => 5,
        :height => 3,
        :distance_unit => :in,
        :weight => order.weight,
        :mass_unit => :g
    }

    shipment = {
        :object_purpose => 'PURCHASE',
        :address_from => address_from,
        :address_to => address_to,
        :parcel => parcel
    }

    if order.weight.to_i < 452
      transaction = Shippo::Transaction.create(
          :shipment => shipment,
          :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
          :servicelevel_token => "usps_first",
          :label_file_type => "PNG"
      )
    else
      transaction = Shippo::Transaction.create(
          :shipment => shipment,
          :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
          :servicelevel_token => "usps_priority",
          :label_file_type => "PNG"
      )
    end

    # binding.pry
    if transaction.object_state == "INVALID"
      order.update_attribute(:error_message, transaction.messages[0].text)
    end


    order.update_attribute(:shipping_label, transaction.label_url)
    order.update_attribute(:tracker, transaction.tracking_url_provider)



  end



end
