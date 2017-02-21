class CustomersController < ApplicationController

before_filter :authorize

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find_by(id: params[:id])
    @orders = Order.where(customer_id: @customer.shopify_id)
  end

  def new

  end

  def create

  end

  def edit
    @customer = Customer.find_by(id: params[:id])
  end

  def update
    @customer = Customer.find_by(id: params[:id])
    @customer.assign_attributes(customer_params)

   if @customer.valid?
     @customer.update_attributes(customer_params)
     redirect_to "/orders/new_orders"
   else
     redirect_to edit_customer_path
    end
  end

  def destroy

  end

  private

  def customer_params
    params.require(:customer).permit(:shopify_id, :first_name, :last_name, :email, :address1, :address2, :city, :state, :country, :zip, :phone, :company)
  end


end
