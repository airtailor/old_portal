module ApplicationHelper
  def doShippo(order,customer)

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

    customer_name = customer['first_name'] + customer['last_name']

    address_to = {
        :object_purpose => 'PURCHASE',
        :name => customer_name,
        :company => '',
        :street1 => customer['address1'],
        :street2 => customer['address2'],
        :city => customer['city'],
        :state => customer['state'],
        :zip => customer['zip'],
        :country => customer['country'],
        :phone => customer['phone'],
        :email => customer['email']
    }

    parcel = {
        :length => 7,
        :width => 5,
        :height => 3,
        :distance_unit => :in,
        :weight => order['total_weight'],
        :mass_unit => :g
    }

    shipment = {
        :object_purpose => 'PURCHASE',
        :address_from => address_from,
        :address_to => address_to,
        :parcel => parcel
    }

    shipment = {
      :shopify_id => order['shopify_id'],
      :shipment => shipment
    }

    Shipment.new(shipment).save




  end
end
