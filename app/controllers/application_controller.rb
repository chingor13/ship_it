class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :request_setup, :load_current_user, :load_projects, :authorize, :set_time_zone

  protected

  def request_setup
    User.current = nil
  end

  def load_current_user
    User.current = User.find_by_id(session[:user_id]) if session.has_key?(:user_id)
  end

  def load_projects
    @projects = Project.all
  end

  def authorize
    redirect_to login_path unless authorized?
  end

  def authorized?
    session[:user_id].present?
  end

  def set_time_zone
    Time.zone = 'Pacific Time (US & Canada)'
  end

end
