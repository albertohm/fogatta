require "uri"
require "net/http"

class SessionsController < ApplicationController
  skip_before_filter :require_login

  def authentication

    # Load data from GitHub
    auth = GitHub.get_auth(params[:code])
    if auth.blank?
      redirect_to root_url, :notice => "We're sorry, but there are some problems with the authentication."
      return
    end

    # Load repositories
    repo_names = GitHub::User.new(auth).repo_names
    if not repo_names.include?(GITHUB_REPOSITORY)
      redirect_to root_url, :notice => "We're sorry, but you can't access."
      return
    end

    session[:user] = {
      uid: auth[:user]['id'],
      token: auth[:token],
      info: {
        image: auth[:user]['avatar_url'],
        nickname: auth[:user]['login']
      }
    }

    redirect_to root_url, :notice => "Welcome #{auth[:user]['login']}!"
  end

  def destroy
    session[:user] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

end
