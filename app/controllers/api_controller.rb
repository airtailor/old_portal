class ApiController < ApplicationController

  protect_from_forgery :except => :recieve

  def recieve
    data = JSON.parse(request.body.read)
    alterations = []
    data['line_items'].each do |item|
        title = ""
        variant_title = ""
        if item['title']
            title = item['title']
        end
        if item['variant_title']
            variant_title = item['variant_title']
        end
        alterations.push(title+" "+variant_title)
    end

    order = {
      name: data['customer']['first_name'],
      shopify_id: data['name'],
      unique_id: data['id'],
      total: data['total_price'],
      weight: data['total_weight'],
      # add order notes
      alterations: alterations
    }

    customer = {
      order_id: data['name'],
      first_name: data['customer']['first_name'],
      last_name: data['customer']['last_name'],
      email: data['customer']['email'],
      address1: data['customer']["default_address"]["address1"],
      address2: data['customer']["default_address"]["address2"],
      city: data['customer']["default_address"]["city"],
      state: data['customer']["default_address"]["province"],
      country: "US",
      zip: data['customer']["default_address"]["zip"],
      phone: data['customer']["default_address"]["phone"],
    }

    @customer = Customer.new(customer).save

    # @exists = Order.where(unique_id: order[:unique_id])

    # if @exists.length > 0
    #     # puts "order exists already"
    #     render nothing: true, status: 200, content_type: "text/html"
    # else
        @order = Order.new(order).save
        render nothing: true, status: 200, content_type: "text/html"
    # end

    saveShippingInfo(order, customer)

  end
end


# @user = User.find_by(id: params[:id])
# @orders = Order.where(user_id: @user.id)

