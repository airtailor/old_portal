class MessagesController < ApplicationController

  def index
    @message = Message.new
    @conversation = Conversation.find_by(id: params[:conversation_id])
    @messages = Message.where(conversation_id: @conversation.id)
    @business = User.find_by(id: @conversation.recipient_id)
    @admin = User.find_by(id: @conversation.sender_id)
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
    params.require(:message).permit(:conversation_id, :user_id, :text, :read)
  end


end
