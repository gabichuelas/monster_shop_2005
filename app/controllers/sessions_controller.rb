class SessionsController < ApplicationController
  def new
    if current_merchant?
      redirect_to '/merchant'
      flash[:success] = "Logged In"
    elsif current_admin?
      redirect_to '/admin'
      flash[:success] = "Logged In"
    elsif current_user
      redirect_to '/profile'
      flash[:success] = "Logged In"
    end
  end

  def create
    # where we set the session[:user_id]
  end
end
