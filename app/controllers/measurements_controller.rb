class MeasurementsController < ApplicationController

 def update
    @measurement = Measurement.find_by(id: params[:id])
    @order = Order.where(name: @measurement.customer_name).first
    @measurement.update_attributes(measurement_params)
    redirect_to :back;
  end
end

private

  def measurement_params
    params.require(:measurement).permit(:customer_id, :customer_name, :sleeve_length, :shoulder_to_waist, :chest_bust, :upper_torso, :waist, :pant_length, :hips, :thigh, :knee, :calf, :ankle, :back_width, :bicep, :elbow, :forearm, :inseam)
  end
