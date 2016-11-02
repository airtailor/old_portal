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
    parcel = shipdata[:parcel]

    if parcel[:weight] == 0
      parcel[:weight] = 1
    end

    address_from = {
      :object_purpose=>"PURCHASE",
      :name=> @user.user_name,
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

    # address_to = {
    #   :object_purpose=>"PURCHASE",
    #   :name=>"Air Tailor",
    #   :company=>"Air Tailor",
    #   :street1=>"510 West 21st Street",
    #   :street2=>"65DM8A",
    #   :city=>"New York",
    #   :state=>"NY",
    #   :zip=>"10011",
    #   :country=>"US",
    #   :phone=>"+1 555 341 9393",
    #   :email=>"orders@airtailor.com"
    # }

    shipment = {
      :object_purpose => 'PURCHASE',
      :address_from => address_from,
      :address_to => address_to,
      :parcel => parcel
    }

    transaction = Shippo::Transaction.create(
        :shipment => shipment,
        :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
        :servicelevel_token => "usps_priority"
    )

    @order.update_attribute(:shipping_label, transaction.label_url)
    redirect_to :back

  end
end
