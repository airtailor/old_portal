class ShipmentsController < ApplicationController
  def makeshipment

    @shipment = Shipment.find_by(shopify_id: params[:id])
    # byebug
    transaction = Shippo::Transaction.create(
        :shipment => @shipment['shipment'],
        :carrier_account => "b741b99f95e841639b54272834bc478c",
        :servicelevel_token => "usps_priority"
    )

  end

end
