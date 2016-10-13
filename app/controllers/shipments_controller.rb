class ShipmentsController < ApplicationController
  def makeshipment

    @shipment = Shipment.find_by(shopify_id: params[:id])
    binding.pry
    Shippo.api_pass = ENV["SHIPPO_KEY"]
    shipdata = eval(@shipment['shipment'])
    transaction = Shippo::Transaction.create(
        :shipment => shipdata,
        :carrier_account => "b741b99f95e841639b54272834bc478c",
        :servicelevel_token => "usps_priority"
    )
  end

end
