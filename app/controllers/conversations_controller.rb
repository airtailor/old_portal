class ConversationsController < ApplicationController

  before_filter :authorize

  def index
    if current_user.is_admin?
      @conversations = Conversation.all
      @users = User.where.not(business_name: "Air Tailor")
    else
      @user = current_user
      if @user.conversation == true
        @conversation = Conversation.where(user_id: current_user.id)
        redirect_to "/conversations/" + @conversation.id.to_s + "/messages"
      else
        @conversation = Conversation.new
      end
    end

    # if current_user.is_admin?
    #   @conversations = Conversation.all
    #   @messages = Message.all
    #   @users = User.where.not(business_name: "Air Tailor")

    # elsif Conversation.exists?(recipient_id: current_user.id)
    #   @conversation = Conversation.where(recipient_id: current_user.id).first

    #   redirect_to "/conversations/" + @conversation.id.to_s + "/messages"
    # else
    #   @conversation = Conversation.new
    # end
  end

  def show
      @conversation = Conversation.find_by(id: params[:id])
      @messages = Message.where(conversation_id: @conversation.id)
      @business = User.find_by(id: @conversation.recipient_id)
  end

  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      redirect_to "/conversations/" + @conversation.id.to_s + "/messages"
    else
      redirect_to "/"
    end
  end

  def edit
    @conversation = Conversation.find_by(id: params[:id])
  end

  def update
    @conversation = Conversation.find_by(id: params[:id])
    @conversation.update_attributes(conversation_params)
    redirect_to @conversation
  end

  def destroy
    @conversation = Conversation.where(id: params[:id])
    @conversation.destroy
    redirect_to '/conversations'
  end

  private

  def conversation_params
    params.require(:conversation).permit(:recipient_id, :sender_id)
  end



end
