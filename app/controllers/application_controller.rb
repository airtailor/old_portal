require 'shippo'
require 'shippo/api/category'
require 'shippo/exceptions/api_error'
require 'json'

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

    #binding.pry

    # require 'shippo/api/category'
    # require 'shippo/exceptions/api_error'

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

# binding.pry

    address_to = {
        :object_purpose => 'PURCHASE',
        :name => customer_name,
        :company => '',
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
        :weight => 1,
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
    # byebug
    Shipment.new(shipment).save
  end



end
