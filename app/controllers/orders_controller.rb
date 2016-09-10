class OrdersController < ApplicationController
  before_filter :authorize

  def index
    if current_user.is_admin?
      @user = User.find_by(id: params[:user_id])
      @orders = Order.where(user_id: @user.id)
      @items = Item.all
      @alterations = Alteration.all
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      @items = Item.all
      @alterations = Alteration.all
    end
  end

end


# @user = User.find_by(id: params[:id])
# @orders = Order.where(user_id: @user.id)

