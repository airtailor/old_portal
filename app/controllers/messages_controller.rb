class MessagesController < ApplicationController

  def index
    if current_user.is_admin?
      @message = Message.new
      @conversation = Conversation.where(id: params[:conversation_id]).first
      @messages = Message.where(conversation_id: @conversation.id)
      @unread = @messages.where(read: false)
      @unread.each do |x|
        x.update_attribute(:read, true)
      end

      if @conversation.sender_id == "2"
        @conversation.update_attribute(:sender_id, "1")
      end

      @business = User.find_by(id: @conversation.recipient_id)
      @admin = User.find_by(id: current_user.id)
    else
      @message = Message.new
      @conversation = Conversation.where(recipient_id: current_user.id).first
      @messages = Message.where(conversation_id: @conversation.id)
      @unread = @messages.where(user_read: false)

      @unread.each do |x|
        x.update_attribute(:user_read, true)
      end

      @business = User.find_by(id: current_user.id)

      if @conversation.sender_id == "2"
        @conversation.update_attribute(:sender_id, "1")
      end
      @admin = User.find_by(id: @conversation.sender_id)
    end
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @conversation = Conversation.find_by(id: params[:conversation_id])
    @sender = User.where(id: @message.user_id).first

    if current_user.is_admin?
      @recipient = User.where(id: @conversation.recipient_id).first
    else
      @recipient = User.where(id: @conversation.sender_id).first
    end

    if @message.order_id
      @message.save
      flash[:success] = "Message Sent"
      redirect_to :back
    else
      @message.save
      AirtailorMailer.message_email(@sender, @recipient, @message).deliver
      redirect_to conversation_messages_path(@conversation)
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to :back
  end

  private

  def message_params
    params.require(:message).permit(:conversation_id, :user_id, :text, :read, :order_id, :user_read)
  end


end
