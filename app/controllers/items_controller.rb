class ItemsController < ApplicationController

  before_filter :authorize


  def index
    @count = 0
    @order = Order.find_by(id: params[:order_id])
    @user = User.find_by(id: params[:user_id])


    # @order.update_attribute(:arrived, true)

    # begin customer measurement section
    if Measurement.exists?(customer_name: @order.name)
      @measurement = Measurement.where(customer_name: @order.name).first
    else
      @measurement = Measurement.create(customer_name: @order.name, sleeve_length: 0, shoulder_to_waist: 0, chest_bust: 0, upper_torso: 0, waist: 0, pant_length: 0, hips: 0, thigh: 0, knee: 0, calf: 0, ankle: 0, back_width: 0, bicep: 0, elbow: 0, forearm: 0, inseam: 0)
    end
    # end customer measurement section

    if current_user.is_admin?
      @items = JSON.parse(@order.alterations)
      # @items = Item.where(order_id: @order.id)
      # @alterations = Alteration.where(order_id: @order.id)


      if Conversation.exists?(recipient_id: @user.id)
        @conversation = Conversation.find_by(recipient_id: @user.id)
        @message = Message.new
      else
        @new_conversation = Conversation.new
      end
    else
      if @order.user_id == current_user.id
        @items = JSON.parse(@order.alterations)
        # @items = Item.where(order_id: @order.id)
        # @alterations = Alteration.where(order_id: @order.id)
      else
        redirect_to "/"
      end

      if Conversation.exists?(recipient_id: @user.id)
        @conversation = Conversation.find_by(recipient_id: current_user.id)
        @message = Message.new
      end
    end
  end

  def update
    @order = Order.find_by(id: params[:order_id])
    @measurement = Measurement.where(customer_name: @order.name).first
    @measurement.update_attributes(measurement_params)
    redirect_to @items

   #  @user = User.find_by(id: params[:id])
   #  @user.assign_attributes(user_params)

   # if @user.valid?
   #   @user.update_attributes(user_params)
   #   redirect_to @user
   # else
   #   redirect_to edit_user_path
   # end
  end

  private

  def measurement_params
    params.require(:measurement).permit(:customer_name, :sleeve_length, :shoulder_to_waist, :chest_bust, :upper_torso, :waist, :pant_length, :hips, :thigh, :knee, :calf, :ankle, :back_width, :bicep, :elbow, :forearm, :inseam)
  end

end
