class ShipmentsController < ApplicationController
  def makeshipment

    @shipment = Shipment.find_by(shopify_id: params[:id])
    Shippo.api_token = ENV["SHIPPO_KEY"]
    shipdata = eval(@shipment['shipment'])
    # debugger
    # address_from = shipdata[:address_from]
    address_to = shipdata[:address_to]
    address_to[:country] = "US"
    # parcel = shipdata[:parcel]



    address_from = {
      :object_purpose=>"PURCHASE",
      :name=>"Air Tailor",
      :company=>"Air Tailor",
      :street1=>"510 West 21st Street",
      :street2=>"65DM8A",
      :city=>"New York",
      :state=>"NY",
      :zip=>"10011",
      :country=>"US",
      :phone=>"+1 555 341 9393",
      :email=>"orders@airtailor.com"
    }

    parcel = {
      :length=>7,
      :width=>5,
      :height=>3,
      :distance_unit=>:in,
      :weight=>1,
      :mass_unit=>:g
    }

    shipment = {
      :object_purpose => 'PURCHASE',
      :address_from => address_from,
      :address_to => address_to,
      :parcel => parcel
    }

    # binding.pry
    transaction = Shippo::Transaction.create(
        # :shipment => shipdata,
        :shipment => shipment,
        :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
        :servicelevel_token => "usps_priority"
    )
    redirect_to :back
  end



end
