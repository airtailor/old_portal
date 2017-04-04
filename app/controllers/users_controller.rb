class UsersController < ApplicationController

  before_filter :authorize

  def admin
    if current_user.is_admin?
      @users = User.all
      @orders = Order.where(user_id: nil)
      @messages = Message.where(read: false)

      @paid_orders = Order.where.not(welcome: true)
      @welcome_kits = Order.where(welcome: true)


      # code for dashboard info:
      # save previous month and current month
      @previous_month = Date.today.prev_month.strftime("%Y%m")
      @current_month = Date.today.strftime("%Y%m")

      # @jan = Date.today.beginning_of_year
      # @feb = @jan + 1.month
      # @mar = @feb + 1.month

      # @jan = @jan.strftime("%Y%m")


      # save current week
      Date.beginning_of_week=(:monday)
      @week_begin = Date.today.beginning_of_week.in_time_zone('Eastern Time (US & Canada)')
      @week_end = Date.today.end_of_week.in_time_zone('Eastern Time (US & Canada)')

      @last_week_begin = @week_begin - 7.days
      @last_week_end = @week_end - 6.days

      @tower_fulfilled = Order.where(user_id: 2, complete: true).where.not(fulfill_date: nil)
      @tower_total = 0



      @this_week = []
      @this_week_rev = 0

      @last_week = []
      @last_week_rev = 0

      @last_month = []
      @last_month_rev = 0

      @this_month = []
      @this_month_rev = 0

      @this_week_kits = []
      @last_week_kits = []
      @this_month_kits = []
      @last_month_kits = []

      @welcome_kits.each do |kit|
        if kit.created_at >= @week_begin && kit.created_at < @week_end
          @this_week_kits.push(kit)
        end
        if kit.created_at >= @last_week_begin && kit.created_at < @last_week_end
          @last_week_kits.push(kit)
        end
        if kit.created_at.strftime("%Y%m") == @current_month
          @this_month_kits.push(kit)
        end
        if kit.created_at.strftime("%Y%m") == @previous_month
          @last_month_kits.push(kit)
        end
      end

      @paid_orders.each do |order|
        if order.created_at >= @last_week_begin && order.created_at < @last_week_end
          @last_week.push(order)
          @last_week_rev += order.total.to_f
        end
        if order.created_at >= @week_begin && order.created_at < @week_end
          @this_week.push(order)
          @this_week_rev += order.total.to_f
        end
        if order.created_at.strftime("%Y%m") == @current_month
          @this_month.push(order)
          @this_month_rev += order.total.to_f
        end
        if order.created_at.strftime("%Y%m") == @previous_month
          @last_month.push(order)
          @last_month_rev += order.total.to_f
        end
      end

      if @last_week.count < 1
        @last_week_rev_per_order = @last_week_rev / 1
      else
        @last_week_rev_per_order = @last_week_rev / @last_week.count
      end

      if @this_week.count < 1
        @this_week_rev_per_order = @this_week_rev / 1
      else
        @this_week_rev_per_order = @this_week_rev / @this_week.count
      end

      if @last_month.count < 1
        @last_month_rev_per_order = @last_month_rev / 1
      else
        @last_month_rev_per_order = @last_month_rev / @last_month.count
      end

      if @this_month.count < 1
        @this_month_rev_per_order = @this_month_rev / 1
      else
        @this_month_rev_per_order = @this_month_rev / @this_month.count
      end

      @previous_week_profit = @last_week_rev * 0.35 - (@last_week.count * 11)
      @current_week_profit = @this_week_rev * 0.35 - (@this_week.count * 11)
      @current_estimated_profit = @this_month_rev * 0.35 - (@this_month.count * 11)
      @previous_estimated_profit = @last_month_rev * 0.35 - (@last_month.count * 11)

    else
      redirect_to current_user
    end
  end

  #
  # end of admin page
  #

  def admin_show
    if current_user.is_admin?
      @users = User.all
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
      @order = Order.find_by(id: params[:id])
      @owner = User.find_by(id: @order.user_id)

      @kits = Order.where(welcome: true)

      if @order.counter != 2
        @order.update_attribute(:counter, 0)
      end

      if @order.weight == "0"
        @order.update_attribute(:weight, "28")
      end

      if @order.inbound_counter != 1
        @order.update_attribute(:inbound_counter, 0)
      end

      @customer = Customer.find_by(order_id: @order.shopify_id)

      @fullname = @customer.first_name.capitalize + " " + @customer.last_name.capitalize
      @order.update_attribute(:name, @fullname)

      if @customer.state == "Washington DC"
        @customer.update_attribute(:state, "DC")
      end

      @owner = User.find_by(id: @order.user_id)
      @alterations = JSON.parse(@order.alterations)

      if @owner && @order.welcome == false
        tailorShippingInfo(@owner, @order, @customer)
      end

      if @owner && @order.inbound_counter != 1 && @order.user_id != 6
        if @order.inbound_label != nil && @order.inbound_label != ""
          AirtailorMailer.label_email(@owner, @customer, @order).deliver
          @order.update_attribute(:inbound_counter, 1)
        end
      end

    else
      redirect_to "/"
    end
  end

  def update_order
    # byebug
    order ={user_id:params['new_owner']}
    @order = Order.find_by(id: params[:order_id])
    @order.update_attributes(order)
    redirect_to :back
  end


  def index
    if current_user.is_admin?
      @users = User.all
      @orders = Order.where(complete: nil)
      # @counter = 0
      # @orders.each do |order|
      #   if order.due_date
      #     if ((((order.due_date - Time.current).to_f)/86400).round) < 0
      #       @counter = @counter + 1
      #     end
      #   end
      # end
    else
      redirect_to "/"
    end
  end

  def show
    if current_user.is_admin?
      @user = User.find_by(id: params[:id])
      @orders = Order.where(user_id: @user.id)
      @orders = @orders.where(arrived: true, complete: nil)
      @counter = 0
      @orders.each do |order|
        if order.due_date
          if ((((order.due_date - Time.current).to_f)/86400).round) < 0
            @counter = @counter + 1
          end
        end
      end
      if @user.conversation == true
        @conversation = Conversation.where(recipient_id: @user.id).first
        @messages = Message.where(conversation_id: @conversation.id)
      else
        @new_conversation = Conversation.new
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      @orders = @orders.where(arrived: true, complete: nil)
      @counter = 0
      @orders.each do |order|
        if order.due_date
          if ((((order.due_date - Time.current).to_f)/86400).round) < 0
            @counter = @counter + 1
          end
        end
      end
      if @user.conversation == true
        @conversation = Conversation.where(recipient_id: current_user.id).first
        @messages = Message.where(conversation_id: @conversation.id)
      end
    end
  end

  def dashboard
    if current_user.is_admin?
      @user = current_user
      @kits = Order.where(welcome: true)
      @orders = Order.where.not(welcome: true)
      if params[:search]
        @orders = @orders.search(params[:search]).order("created_at DESC")
        @kits = @kits.search(params[:search]).order("created_at DESC")
      end
      @total = 0
      @profit = 0
    else
      redirect_to current_user
    end

  end

  def supplies
    @user = User.find_by(id: params[:id])
  end

  def new
    if current_user.is_admin?
      @user = User.new
    else
      redirect_to "/"
    end
  end

  def create
    if current_user.is_admin?
       @user = User.new(user_params)
       if @user.save
          #session[:user_id] = @user.id
          redirect_to @user
       else
         redirect_to new_user_path
       end
     else
       redirect_to "/"
     end
  end

  def edit
    if current_user.is_admin?
      @user = User.find_by(id: params[:id])
    else
      @user = current_user
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.assign_attributes(user_params)

   if @user.valid?
     @user.update_attributes(user_params)
     redirect_to @user
   else
     redirect_to edit_user_path
     flash[:user_edit_error] = "Error — Missing Field(s)"
   end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :business_name, :email, :password, :password_confirmation, :phone, :street, :unit, :city, :state, :zip, :country, :timezone, :conversation)
  end



end
