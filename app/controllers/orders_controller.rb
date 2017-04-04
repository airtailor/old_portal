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
      @orders.each do |order|
        @items = JSON.parse(order.alterations)
        if order.total == "0.00" && @items.any? { |s| s.include?('Welcome') }
          order.update_attribute(:welcome, true)
          order.update_attribute(:user_id, 1)
          order.update_attribute(:arrived, true)
          order.update_attribute(:complete, true)
        end
      end

      @kits = Order.where(welcome: true).where(user_id: 1).where(shipping_label: nil).where.not(counter: 2)


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


  def reports

    @tailors = User.where.not(email: "test@burberry.com")
    @total = 0
    @nov_total = 0
    @dec_total = 0
    @jan_total = 0
    @feb_total = 0

    # 2016
    @nov16_orders = Order.where('extract(month from created_at) = ? and extract(year from created_at) = ?', 11, 2016).where.not(welcome: true)
    @dec16_orders = Order.where('extract(month from created_at) = ? and extract(year from created_at) = ?', 12, 2016).where.not(welcome: true)

    # 2017
    @jan17_orders = Order.where('extract(month from created_at) = ? and extract(year from created_at) = ?', 1, 2017).where.not(welcome: true)
    @feb17_orders = Order.where('extract(month from created_at) = ? and extract(year from created_at) = ?', 2, 2017).where.not(welcome: true)

  end


  def invoice_details
    @order = Order.find_by(id: params[:id])
    @items = JSON.parse(@order.alterations)
    @customer = Customer.where(order_id: @order.shopify_id).first
    @user = User.where(id: @order.user_id).first
  end



  def archive
    if current_user.is_admin?
      @user = current_user
      @users = User.all
      @orders = Order.where(complete: true)
      @orders = @orders.where.not(shipping_label: nil)
      @orders = @orders.where.not(welcome: true)
      @alts = []
      @orders.each do |order|
        @alts.push(JSON.parse(order.alterations))
        if order.fulfill_date.blank?
          order.update_attribute(:fulfill_date, order.due_date)
        end
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      @orders = @orders.where(complete: true)
      @orders = @orders.where.not(shipping_label: nil)
      @orders.each do |order|
        if order.fulfill_date.blank?
          order.update_attribute(:fulfill_date, order.due_date)
        end
      end
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


