class OrdersController < ApplicationController
  before_filter :authorize

  def index
    if current_user.is_admin?
      @user = User.find_by(id: params[:user_id])
      @orders = Order.where(user_id: @user.id)
      @orders = @orders.where(complete: nil)
      @alts = []
      if params[:search]
        @orders = Order.where.not(user_id: nil)
        @orders = @orders.search(params[:search]).order("created_at DESC")
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      @orders = @orders.where(complete: nil)
      @alts = []
      if params[:search]
        @orders = @orders = Order.where(user_id: current_user.id)
        @orders = @orders.search(params[:search]).order("created_at DESC")
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
      if @order.user_id.blank?
        @order.update_attribute(:arrived, nil)
        @order.update_attribute(:complete, nil)
        @order.update_attribute(:counter, 0)
        @order.update_attribute(:inbound_counter, 0)
        @order.update_attribute(:inbound_label, nil)
        redirect_to "/orders/new_orders"
      elsif @order.inbound_counter == 2
        redirect_to "/users/" + @order.user_id.to_s + "/orders/" + @order.id.to_s + "/items"
      else
        redirect_to :back
      end
    else
      redirect_to edit_order_path
    end
  end

  def edit
    if current_user.is_admin?
      @order = Order.find_by(id: params[:id])
      @users = User.where.not(id: @order.user_id)
      @user = User.where(id: @order.user_id).first
      @order.update_attribute(:inbound_counter, 2)
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
    params.require(:order).permit(:name, :shopify_id, :unique_id, :total, :alterations, :user_id, :arrival_date, :due_date, :complete, :arrived, :customer_id, :counter, :shipping_label, :note, :inbound_label, :inbound_counter, :welcome, :weight, :tracker, :tailor_notes, :fulfill_date)
  end

end


