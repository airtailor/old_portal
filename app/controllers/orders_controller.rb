class OrdersController < ApplicationController
  before_filter :authorize

  def index
    if current_user.is_admin?
      @user = User.find_by(id: params[:user_id])
      @orders = Order.where(user_id: @user.id)
      @alts = []
      @orders.each do |order|
        @alts.push(JSON.parse(order.alterations))
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
    end
  end

  {"Shirt #1"=>"Add Collar Buttons, Add Snaps Under Collar", "Pants #1"=>"Add Button, Add Clasp"}
  def to_hash(string)

  end

end

