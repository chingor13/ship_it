class SessionsController < ApplicationController

  layout 'homepage'
  skip_before_filter :authorize

  def homepage
  end

  def new
    pp OmniAuth.strategies
    pp OmniAuth::Builder.providers
  end

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    session[:user_name] = @user.name
    redirect_to projects_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end