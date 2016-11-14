class MessagesController < ApplicationController

  def index
    if current_user.is_admin?
      @message = Message.new
      @conversation = Conversation.find_by(id: params[:conversation_id])
      @messages = Message.where(conversation_id: @conversation.id)
      @unread = @messages.where(read: false)
      @unread.each do |x|
        x.update_attribute(:read, true)
      end

      @business = User.find_by(id: @conversation.recipient_id)
      @admin = User.find_by(id: @conversation.sender_id)
    else
      @message = Message.new
      @conversation = Conversation.find_by(recipient_id: current_user.id)
      @messages = Message.where(conversation_id: @conversation.id)
      @unread = @messages.where(user_read: false)

      @unread.each do |x|
        x.update_attribute(:user_read, true)
      end

      @business = User.find_by(id: current_user.id)
      @admin = User.find_by(id: @conversation.sender_id)
    end
  end

  def new
    @message = Message.new
  end

  def create
     @message = Message.new(message_params).save
     @conversation = Conversation.find_by(id: params[:conversation_id])
        redirect_to conversation_messages_path(@conversation)
     # else
       # redirect_to "/users/new"
     # end
  end

  private

  def message_params
    params.require(:message).permit(:conversation_id, :user_id, :text, :read, :order_id)
  end


end
