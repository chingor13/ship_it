class SessionsController < ApplicationController

  layout 'homepage'
  skip_before_filter :authorize, only: [:homepage]

  def homepage
  end

  def create
    # fixme
  end

  def destroy
    reset_session
    redirect_to root_path
  end

end