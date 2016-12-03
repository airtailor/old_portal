class OrdersController < ApplicationController
  before_filter :authorize

  def index
    if current_user.is_admin?
      @user = User.find_by(id: params[:user_id])
      @orders = Order.where(user_id: @user.id)
      @orders = @orders.where(complete: nil)
      @alts = []
      @orders.each do |order|
        @alts.push(JSON.parse(order.alterations))
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      @orders = @orders.where(complete: nil)
      @alts = []
      @orders.each do |order|
        @alts.push(JSON.parse(order.alterations))
      end
    end
  end

  def new_orders
    if current_user.is_admin?
      @orders = Order.where(user_id: nil)
    else
      redirect_to "/"
    end
  end

  def order_complete
    @user = User.find_by(id: params[:user_id])
    @order = Order.find_by(id: params[:id])
    @customer = Customer.where(order_id: @order.shopify_id).first
    @alterations = JSON.parse(@order.alterations)
  end

  def archive
    if current_user.is_admin?
      @users = User.all
      @orders = Order.where(complete: true)
      @orders = @orders.where.not(shipping_label: nil)
      @alts = []
      @orders.each do |order|
        @alts.push(JSON.parse(order.alterations))
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      @orders = @orders.where(complete: true)
      @orders = @orders.where.not(shipping_label: nil)
    end
  end

  {"Shirt #1"=>"Add Collar Buttons, Add Snaps Under Collar", "Pants #1"=>"Add Button, Add Clasp"}
  def to_hash(string)

  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.assign_attributes(order_params)

    if @order.valid?
      @order.update_attributes(order_params)
      if @order.welcome != nil
        redirect_to :back
      else
        redirect_to "/users/" + @order.user_id.to_s + "/orders/" + @order.id.to_s + "/items"
      end
    else
      redirect_to edit_order_path
    end
  end

  def edit
    if current_user.is_admin?
      @order = Order.find_by(id: params[:id])
    else
      redirect_to :back
    end
  end

  def destroy
    @user = User.find_by(id: params[:user_id])
    @order = Order.find_by(id: params[:id])
    @order.destroy
    redirect_to "/users/" + @user.id.to_s + "/orders"
  end

  private

  def order_params
    params.require(:order).permit(:name, :shopify_id, :unique_id, :total, :alterations, :user_id, :arrival_date, :due_date, :complete, :arrived, :customer_id, :counter, :shipping_label, :note, :inbound_label, :inbound_counter, :welcome, :weight, :tracker, :tailor_notes)
  end

end


