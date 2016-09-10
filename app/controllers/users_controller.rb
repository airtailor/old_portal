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
      # @orders = Order.where(user_id: @user.id)
      # @late_orders = @orders.where(status: "late")
    else
      @user = current_user
      # @orders = Order.where(user_id: current_user.id)
      # @late_orders = @orders.where(status: "late")
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
     @user = User.new(user_params).save
     # if @user.save
        # session[:user_id] = @user.id
        redirect_to "/admin"
     # else
       # redirect_to "/users/new"
     # end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.update_attributes(user_params)
    redirect_to @user
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
