class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    @message = Message.create!(params[:message].merge({author: current_user[:info][:nickname]}))
    PrivatePub.publish_to("/messages/new", message: @message)
  end
end
