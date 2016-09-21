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
      name: data['email'],
      shopify_id: data['number'],
      unique_id: data['id'],
      total: data['total_price'],
      alterations: alterations
    }

    @exists = Order.where(unique_id: order[:unique_id])
    if @exists.length > 0
        # puts "order exists already"
        render nothing: true, status: 200, content_type: "text/html"
    else
        @order = Order.new(order).save
        render nothing: true, status: 200, content_type: "text/html"
    end 

  end
end


# @user = User.find_by(id: params[:id])
# @orders = Order.where(user_id: @user.id)

