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
      @admin = User.find_by(id: current_user.id)
    else
      @message = Message.new
      @conversation = Conversation.find_by(recipient_id: current_user.id)
      @messages = Message.where(conversation_id: @conversation.id)
      @unread = @messages.where(user_read: false)

      @unread.each do |x|
        x.update_attribute(:user_read, true)
      end

      @business = User.find_by(id: current_user.id)
      if @conversation.sender_id == 2
        @conversation.update_attribute(:sender_id, 1)
      end
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
