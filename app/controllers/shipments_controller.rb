class ShipmentsController < ApplicationController

  def makeshipment
    @shipment = Shipment.find_by(shopify_id: params[:id])
    @order = Order.where(shopify_id: @shipment.shopify_id).first
    @user = User.where(id: @order.user_id).first
    @order.update_attribute(:complete, true)

    Shippo.api_token = ENV["SHIPPO_KEY"]
    shipdata = eval(@shipment['shipment'])

    address_to = shipdata[:address_to]
    address_to[:country] = "US"
    # address_to[:state] = "District of Columbia"
    parcel = shipdata[:parcel]

    if @order.welcome == true
      parcel = {
          :length => 6,
          :width => 4,
          :height => 1,
          :distance_unit => :in,
          :weight => "28",
          :mass_unit => :g
      }
    end

    if parcel[:weight] == "0"
      parcel[:weight] = "28"
    end

    if parcel[:weight] == 0
      parcel[:weight] = 28
    end

    address_from = {
      :object_purpose=>"PURCHASE",
      :name=> "Air Tailor",
      :company=> "",
      :street1=> @user.street,
      :street2=> @user.unit,
      :city=> @user.city,
      :state=> @user.state,
      :zip=> @user.zip,
      :country=> "US",
      :phone=> @user.phone,
      :email=> @user.email
    }

    if address_from[:state] == "Washington DC"
      address_from[:state] = "DC"
    end

    if address_to[:state] == "Washington DC"
      address_to[:state] = "DC"
    end

    shipment = {
      :object_purpose => 'PURCHASE',
      :address_from => address_from,
      :address_to => address_to,
      :parcel => parcel
    }

    # binding.pry

    if @order.welcome == true
      transaction = Shippo::Transaction.create(
          :shipment => shipment,
          :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
          :servicelevel_token => "usps_first",
          :label_file_type => "PNG"
      )
    elsif @order.weight.to_i < 452
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

    @order.update_attribute(:shipping_label, transaction.label_url)
    @order.update_attribute(:tracking_number, transaction.tracking_number)
    redirect_to :back

  end
end
