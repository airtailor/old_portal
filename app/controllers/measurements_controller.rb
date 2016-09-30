class MeasurementsController < ApplicationController

 def update
    @measurement = Measurement.find_by(id: params[:id])
    @order = Order.where(name: @measurement.customer_name).first
    @measurement.update_attributes(measurement_params)
    redirect_to :back;
  end
end
