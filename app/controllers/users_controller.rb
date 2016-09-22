class UsersController < ApplicationController

  before_filter :authorize

  def admin
    if current_user.is_admin?
      @users = User.all
      @orders = Order.all
    else
      redirect_to current_user
    end
  end

  def admin_show
    if current_user.is_admin?
      @users = User.all
      @order = Order.find_by(id: params[:id])
      @owner = User.find_by(id: @order.user_id)
      @alterations = JSON.parse(@order.alterations)
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
    else
      redirect_to "/"
    end
  end

  def show
    if current_user.is_admin?
      @user = User.find_by(id: params[:id])
      @orders = Order.where(user_id: @user.id)
      if Conversation.exists?(recipient_id: @user.id)
        @conversation = Conversation.find_by(recipient_id: @user.id)
        @messages = Message.where(conversation_id: @conversation.id)
      else
        @new_conversation = Conversation.new
      end
    else
      @user = current_user
      @orders = Order.where(user_id: current_user.id)
      if Conversation.exists?(recipient_id: @user.id)
        @conversation = Conversation.find_by(recipient_id: current_user.id)
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
   end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    session.clear
    @user.destroy
    redirect_to '/users/index'
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :business_name, :email, :password, :password_confirmation, :phone, :street, :unit, :city, :state, :zip, :country, :timezone)
  end



end