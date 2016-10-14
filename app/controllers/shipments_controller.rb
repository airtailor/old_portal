class ShipmentsController < ApplicationController
  def makeshipment

    @shipment = Shipment.find_by(shopify_id: params[:id])
    Shippo.api_token = ENV["SHIPPO_KEY"]
    # binding.pry
    # shipdata = eval(@shipment['shipment'])
    # debugger

    address_from = {
        :object_purpose => 'PURCHASE',
        :name => 'Shawn Ippotle',
        :company => 'Shippo',
        :street1 => '215 Clayton St.',
        :street2 => '',
        :city => 'San Francisco',
        :state => 'CA',
        :zip => '94117',
        :country => 'US',
        :phone => '+1 555 341 9393',
        :email => 'shippotle@goshippo.com'
    }

    address_to = {
        :object_purpose => 'PURCHASE',
        :name => 'Mr Hippo"',
        :company => '',
        :street1 => 'Broadway 1',
        :street2 => '',
        :city => 'New York',
        :state => 'NY',
        :zip => '10007',
        :country => 'US',
        :phone => '+1 555 341 9393',
        :email => 'mrhippo@goshippo.com'
    }

    parcel = {
        :length => 5,
        :width => 1,
        :height => 5.555,
        :distance_unit => :cm,
        :weight => 2,
        :mass_unit => :lb
    }

    shipment = {
    :object_purpose => 'PURCHASE',
    :address_from => address_from,
    :address_to => address_to,
    :parcel => parcel
  }

    transaction = Shippo::Transaction.create(
        # :shipment => shipdata,
        :shipment => shipment, #@shipment[:shipment],
        :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
        :servicelevel_token => "usps_priority"
    )

    render :nothing => true
  end



end
