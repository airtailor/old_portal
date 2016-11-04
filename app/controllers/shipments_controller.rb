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
      parcel[:weight] = 57
    end

    address_from = {
      :object_purpose=>"PURCHASE",
      :name=> user.user_name,
      :company=> user.business_name,
      :street1=> user.street,
      :street2=> user.unit,
      :city=> user.city,
      :state=> user.state,
      :zip=> user.zip,
      :country=> "US",
      :phone=> user.phone,
      :email=> user.email
    }

    shipment = {
      :object_purpose => 'PURCHASE',
      :address_from => address_from,
      :address_to => address_to,
      :parcel => parcel
    }

    transaction = Shippo::Transaction.create(
        :shipment => shipment,
        :carrier_account => "d11e35a8792942fdb9b17d39246e3621",
        :servicelevel_token => "usps_priority",
        :label_file_type => "PNG"
    )

    @order.update_attribute(:shipping_label, transaction.label_url)
    redirect_to :back

  end
end
