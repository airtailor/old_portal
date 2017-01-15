class UsersController < ApplicationController

  before_filter :authorize

  def admin
    if current_user.is_admin?
      @users = User.all
      @orders = Order.where(user_id: nil)
      @total_orders = Order.where.not(welcome: true)
      @messages = Message.where(read: false)

      # code to figure out # of orders each month
      @current_month = Date.today.strftime("%Y%m")
      @this_month = []
      @total_orders.each do |order|
        if order.created_at.strftime("%Y%m") == @current_month
          @this_month.push(order)
        end
      end




    else
      redirect_to current_user
    end
  end

  def admin_show
    if current_user.is_admin?
      @users = User.all
      @orders = Order.where(user_id: nil)
      @order = Order.find_by(id: params[:id])

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

      if @owner && @order.inbound_counter != 1
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
