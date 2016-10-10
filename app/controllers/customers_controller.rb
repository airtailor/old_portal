class CustomersController < ApplicationController

before_filter :authorize

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find_by(id: params[:id])
    @orders = Order.where(customer_id: @customer.unique_id)
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def customer_params
    params.require(:customer).permit()
  end



end
