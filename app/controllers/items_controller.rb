class ItemsController < ApplicationController

  before_filter :authorize


  def index
    @count = 0
    @order = Order.find_by(id: params[:order_id])
    if current_user.is_admin?
      @items = JSON.parse(@order.alterations)
      # @items = Item.where(order_id: @order.id)
      # @alterations = Alteration.where(order_id: @order.id)
    else
      if @order.user_id == current_user.id
        @items = JSON.parse(@order.alterations)
        # @items = Item.where(order_id: @order.id)
        # @alterations = Alteration.where(order_id: @order.id)
      else
        redirect_to "/"
      end
    end
  end

end
