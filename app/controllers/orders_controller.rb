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
      @alts = []
      @orders.each do |order|
        @alts.push(JSON.parse(order.alterations))
      end
    end
  end

  {"Shirt #1"=>"Add Collar Buttons, Add Snaps Under Collar", "Pants #1"=>"Add Button, Add Clasp"}
  def to_hash(string)

  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.update_attributes(order_params)
    redirect_to :back

  end

  private

  def order_params
    params.require(:order).permit(:name, :shopify_id, :unique_id, :total, :alterations, :user_id, :arrival_date, :due_date, :complete, :arrived, :customer_id)
  end

end


