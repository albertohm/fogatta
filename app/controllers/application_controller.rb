class ApplicationController < ActionController::Base
  before_filter :require_login
  protect_from_forgery
  helper_method :current_user

  protected

  def current_user
    session[:user]
  end

  def require_login
    render :template => "session/info" unless current_user
  end
end
