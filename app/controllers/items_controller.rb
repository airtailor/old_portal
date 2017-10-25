class ItemsController < ApplicationController
  before_filter :authorize

  def index
    @order = Order.find_by(id: params[:order_id])
    @customer = Customer.where(order_id: @order.shopify_id).first
    @user = User.find_by(id: params[:user_id])
    @alterations = JSON.parse(@order.alterations)
    if Shipment.exists?(shopify_id: @order.shopify_id)
      @shipment = Shipment.where(shopify_id: @order.shopify_id)
    end

    fullname = @customer.first_name.capitalize + " " + @customer.last_name.capitalize

    @order.update_attribute(:name, fullname)



    # sonar shit
    if @order.arrived == true && @order.counter == 0
      if @customer.phone.blank?
      else
        SendSonar.message_customer(text: "Hi " + @customer.first_name.capitalize + ", just a heads up that your Air Tailor order (" + @order.shopify_id + ") has been received! We're going to get to work.", to: @customer.phone)
        sleep 3
        if @customer.address2.blank?
          SendSonar.message_customer(text: "When we're done, we'll ship it directly to " + @customer.address1 + ", " + @customer.city + ", " + @customer.state + " " + @customer.zip + ". Is that still correct? Thank you!", to: @customer.phone)
        else
          SendSonar.message_customer(text: "When we're done, we'll ship it directly to " + @customer.address1 + ", " + @customer.address2 + ", " + @customer.city + ", " + @customer.state + " " + @customer.zip + ". Is that still correct? Thank you!", to: @customer.phone)
        end
      end
      @order.update_attribute(:counter, 1)
    end

    if @order.complete == true && @order.counter == 1
      if @customer.phone.blank?
      else
        SendSonar.message_customer(text: "Good news " + @customer.first_name.capitalize + " — your Air Tailor order (" + @order.shopify_id + ") is finished and on its way to you! Here's your USPS tracking number: " + @order.tracking_number, to: @customer.phone)
      end
      @order.update_attribute(:counter, 2)
    end
    # end sonar shit

    # begin customer measurement section
    if Measurement.exists?(customer_name: @order.name)
      @measurement = Measurement.where(customer_name: @order.name).first
    # elsif Measurement.exists?(customer_id: @customer.shopify_id)
    #   @measurement = Measurement.where(customer_id: @customer.shopify_id).first
    else
      @measurement = Measurement.create(customer_id: @customer.shopify_id, customer_name: @order.name, sleeve_length: 0, shoulder_to_waist: 0, chest_bust: 0, upper_torso: 0, waist: 0, pant_length: 0, hips: 0, thigh: 0, knee: 0, calf: 0, ankle: 0, back_width: 0, bicep: 0, elbow: 0, forearm: 0, inseam: 0)
    end
    # binding.pry
    # end customer measurement section

    if current_user.is_admin?
      @items = JSON.parse(@order.alterations)
      # @items = Item.where(order_id: @order.id)
      # @alterations = Alteration.where(order_id: @order.id)


      if @user.conversation == true
        @conversation = Conversation.where(recipient_id: @user.id).first
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

      if @user.conversation == true
        @conversation = Conversation.where(recipient_id: current_user.id).first
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
